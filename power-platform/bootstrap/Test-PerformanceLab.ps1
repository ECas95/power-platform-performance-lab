param(
    [Parameter(Mandatory = $true)]
    [string]$EnvironmentUrl,

    [string]$SolutionUniqueName = "PowerPlatformPerformanceLab",
    [string]$PublisherPrefix = "pppl",
    [string]$AccessToken = $env:POWERPLATFORM_ACCESS_TOKEN
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$EnvironmentUrl = $EnvironmentUrl.TrimEnd("/")
$ApiRoot = "$EnvironmentUrl/api/data/v9.2"

function Get-PpplAccessToken {
    if ($AccessToken) {
        return $AccessToken.Trim()
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

$token = Get-PpplAccessToken
$headers = @{
    Authorization = "Bearer $token"
    Accept = "application/json"
    "OData-MaxVersion" = "4.0"
    "OData-Version" = "4.0"
}

function Invoke-Get {
    param([Parameter(Mandatory = $true)][string]$RelativePath)
    return Invoke-RestMethod -Method GET -Uri "$ApiRoot/$RelativePath" -Headers $headers
}

function Assert-Column {
    param(
        [Parameter(Mandatory = $true)][string]$Table,
        [Parameter(Mandatory = $true)][string]$Column
    )

    $path = "EntityDefinitions(LogicalName='$Table')/Attributes(LogicalName='$Column')" + '?$select=LogicalName,SchemaName'
    $result = Invoke-Get $path
    if ($result.LogicalName -ne $Column) {
        throw "Column validation failed: $Table.$Column"
    }
    Write-Host "OK column: $Table.$Column"
}

$solutionFilter = [Uri]::EscapeDataString("uniquename eq '$SolutionUniqueName'")
$solutionPath = 'solutions?$select=solutionid,uniquename,version&$filter=' + $solutionFilter
$solutionResult = Invoke-Get $solutionPath

if ($solutionResult.value.Count -ne 1) {
    throw "Expected exactly one solution named '$SolutionUniqueName'."
}

Write-Host "OK solution: $SolutionUniqueName version $($solutionResult.value[0].version)"

$recordTable = "${PublisherPrefix}_benchmarkrecord"
$runTable = "${PublisherPrefix}_benchmarkrun"

$recordMeta = Invoke-Get ("EntityDefinitions(LogicalName='$recordTable')" + '?$select=LogicalName,EntitySetName')
$runMeta = Invoke-Get ("EntityDefinitions(LogicalName='$runTable')" + '?$select=LogicalName,EntitySetName')

Write-Host "OK table: $($recordMeta.LogicalName) / $($recordMeta.EntitySetName)"
Write-Host "OK table: $($runMeta.LogicalName) / $($runMeta.EntitySetName)"

$recordColumns = @(
    "${PublisherPrefix}_externalkey",
    "${PublisherPrefix}_datasettag",
    "${PublisherPrefix}_businessunitcode",
    "${PublisherPrefix}_category",
    "${PublisherPrefix}_status",
    "${PublisherPrefix}_sequencenumber",
    "${PublisherPrefix}_sortkey",
    "${PublisherPrefix}_isselected",
    "${PublisherPrefix}_payloadtext"
)

$runColumns = @(
    "${PublisherPrefix}_correlationid",
    "${PublisherPrefix}_benchmarkid",
    "${PublisherPrefix}_pattern",
    "${PublisherPrefix}_datasetsize",
    "${PublisherPrefix}_runnumber",
    "${PublisherPrefix}_durationms",
    "${PublisherPrefix}_recordsreturned",
    "${PublisherPrefix}_requestcount",
    "${PublisherPrefix}_outcome",
    "${PublisherPrefix}_evidencelevel",
    "${PublisherPrefix}_notes"
)

foreach ($column in $recordColumns) {
    Assert-Column -Table $recordTable -Column $column
}

foreach ($column in $runColumns) {
    Assert-Column -Table $runTable -Column $column
}

Write-Host ""
Write-Host "Power Platform Performance Lab metadata validation passed."
