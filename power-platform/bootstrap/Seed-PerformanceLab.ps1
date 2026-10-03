param(
    [Parameter(Mandatory = $true)]
    [string]$EnvironmentUrl,

    [ValidateRange(1, 1000000)]
    [int]$Count = 500,

    [int]$Seed = 42,

    [ValidateRange(1, 1000)]
    [int]$BatchSize = 100,

    [string]$PublisherPrefix = "pppl",
    [string]$DatasetTag,
    [switch]$AllowExisting,
    [string]$AccessToken = $env:POWERPLATFORM_ACCESS_TOKEN
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$EnvironmentUrl = $EnvironmentUrl.TrimEnd("/")
$ApiRoot = "$EnvironmentUrl/api/data/v9.2"

if (-not $DatasetTag) {
    $DatasetTag = "seed-$Seed-$Count"
}

function Get-PpplAccessToken {
    if ($AccessToken) {
        return $AccessToken.Trim()
    }

    $pac = Get-Command pac -ErrorAction SilentlyContinue
    if (-not $pac) {
        throw "Power Platform CLI (pac) is required when -AccessToken is not supplied."
    }

    $lines = @(pac auth token 2>&1)
    if ($LASTEXITCODE -ne 0) {
        throw "pac auth token failed: $($lines -join [Environment]::NewLine)"
    }

    $candidate = $lines |
        ForEach-Object { "$_".Trim() } |
        Where-Object { $_ -and $_ -notmatch "^(Power Platform CLI|Version|Error)" } |
        Select-Object -Last 1

    if (-not $candidate) {
        throw "Unable to obtain an access token from pac auth token."
    }

    if ($candidate.StartsWith("Bearer ", [System.StringComparison]::OrdinalIgnoreCase)) {
        $candidate = $candidate.Substring(7)
    }

    return $candidate
}

$script:Token = Get-PpplAccessToken

function Invoke-DvRequest {
    param(
        [Parameter(Mandatory = $true)][ValidateSet("GET", "POST")][string]$Method,
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [object]$Body
    )

    $headers = @{
        Authorization = "Bearer $script:Token"
        Accept = "application/json"
        "OData-MaxVersion" = "4.0"
        "OData-Version" = "4.0"
        "If-None-Match" = "null"
    }

    $params = @{
        Method = $Method
        Uri = "$ApiRoot/$RelativePath"
        Headers = $headers
    }

    if ($null -ne $Body) {
        $params["ContentType"] = "application/json; charset=utf-8"
        $params["Body"] = ($Body | ConvertTo-Json -Depth 15 -Compress)
    }

    return Invoke-RestMethod @params
}

$tableLogicalName = "${PublisherPrefix}_benchmarkrecord"
$metadataPath = "EntityDefinitions(LogicalName='$tableLogicalName')" + '?$select=LogicalName,EntitySetName'
$metadata = Invoke-DvRequest -Method GET -RelativePath $metadataPath

if (-not $metadata.EntitySetName) {
    throw "Unable to resolve EntitySetName for $tableLogicalName."
}

$entitySet = $metadata.EntitySetName
$escapedTag = $DatasetTag.Replace("'", "''")
$existingPath = $entitySet + '?$select=' + "${PublisherPrefix}_benchmarkrecordid" + '&$top=1&$filter=' + [Uri]::EscapeDataString("${PublisherPrefix}_datasettag eq '$escapedTag'")
$existing = Invoke-DvRequest -Method GET -RelativePath $existingPath

if ($existing.value.Count -gt 0 -and -not $AllowExisting) {
    throw "DatasetTag '$DatasetTag' already exists. Choose another tag or pass -AllowExisting intentionally."
}

$categories = @("Alpha", "Beta", "Gamma", "Delta")
$statuses = @("Active", "Pending", "Closed", "Archived")
$businessUnits = @("U01", "U02", "U03", "U04", "U05", "U06", "U07", "U08")
$random = [System.Random]::new($Seed)
$records = [System.Collections.Generic.List[object]]::new()

Write-Host "Seeding $Count synthetic rows into $entitySet"
Write-Host "Dataset tag: $DatasetTag"
Write-Host "Batch size: $BatchSize"

for ($i = 1; $i -le $Count; $i++) {
    $externalKey = "R{0:D8}" -f $i
    $payloadSize = 128 + (($i * 37) % 1024)
    $payload = ("X" * $payloadSize)

    $record = @{
        "@odata.type" = "Microsoft.Dynamics.CRM.$tableLogicalName"
        "${PublisherPrefix}_name" = "Benchmark $externalKey"
        "${PublisherPrefix}_externalkey" = $externalKey
        "${PublisherPrefix}_datasettag" = $DatasetTag
        "${PublisherPrefix}_businessunitcode" = $businessUnits[$random.Next(0, $businessUnits.Count)]
        "${PublisherPrefix}_category" = $categories[$random.Next(0, $categories.Count)]
        "${PublisherPrefix}_status" = $statuses[$random.Next(0, $statuses.Count)]
        "${PublisherPrefix}_sequencenumber" = $i
        "${PublisherPrefix}_sortkey" = $random.Next(0, 1000000)
        "${PublisherPrefix}_isselected" = [int](($i % 7) -eq 0)
        "${PublisherPrefix}_payloadtext" = $payload
    }

    $records.Add($record)

    if ($records.Count -ge $BatchSize -or $i -eq $Count) {
        $body = @{ Targets = @($records) }
        $path = "$entitySet/Microsoft.Dynamics.CRM.CreateMultiple"
        $response = Invoke-DvRequest -Method POST -RelativePath $path -Body $body

        if (-not $response.Ids -or $response.Ids.Count -ne $records.Count) {
            throw "CreateMultiple returned an unexpected result for a batch ending at row $i."
        }

        Write-Host "Created $i / $Count"
        $records.Clear()
    }
}

Write-Host "Seed completed: $DatasetTag"
