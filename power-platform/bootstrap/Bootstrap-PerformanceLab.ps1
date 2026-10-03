param(
    [Parameter(Mandatory = $true)]
    [string]$EnvironmentUrl,

    [string]$SolutionUniqueName = "PowerPlatformPerformanceLab",
    [string]$PublisherUniqueName = "ppplperformancepublisher",
    [string]$PublisherPrefix = "pppl",
    [int]$OptionValuePrefix = 93600,
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

function New-LocalizedLabel {
    param([Parameter(Mandatory = $true)][string]$Text)

    return @{
        "@odata.type" = "Microsoft.Dynamics.CRM.Label"
        LocalizedLabels = @(
            @{
                "@odata.type" = "Microsoft.Dynamics.CRM.LocalizedLabel"
                Label = $Text
                LanguageCode = 1033
            }
        )
    }
}

function New-RequiredLevelNone {
    return @{
        Value = "None"
        CanBeChanged = $true
        ManagedPropertyLogicalName = "canmodifyrequirementlevelsettings"
    }
}

function Invoke-DvRequest {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "PATCH", "PUT", "DELETE")]
        [string]$Method,

        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [object]$Body,
        [switch]$SolutionScoped
    )

    $headers = @{
        Authorization = "Bearer $script:Token"
        Accept = "application/json"
        "OData-MaxVersion" = "4.0"
        "OData-Version" = "4.0"
        "If-None-Match" = "null"
    }

    if ($SolutionScoped) {
        $headers["MSCRM.SolutionUniqueName"] = $SolutionUniqueName
    }

    $uri = "$ApiRoot/$RelativePath"

    $params = @{
        Method = $Method
        Uri = $uri
        Headers = $headers
    }

    if ($null -ne $Body) {
        $params["ContentType"] = "application/json; charset=utf-8"
        $params["Body"] = ($Body | ConvertTo-Json -Depth 30 -Compress)
    }

    return Invoke-RestMethod @params
}

function Get-OneByUniqueName {
    param(
        [Parameter(Mandatory = $true)][string]$EntitySet,
        [Parameter(Mandatory = $true)][string]$UniqueName,
        [Parameter(Mandatory = $true)][string]$Select
    )

    $filter = [Uri]::EscapeDataString("uniquename eq '$UniqueName'")
    $path = $EntitySet + '?$select=' + $Select + '&$filter=' + $filter
    $result = Invoke-DvRequest -Method GET -RelativePath $path

    if ($result.value.Count -gt 0) {
        return $result.value[0]
    }

    return $null
}

function Test-TableExists {
    param([Parameter(Mandatory = $true)][string]$LogicalName)

    try {
        $path = "EntityDefinitions(LogicalName='$LogicalName')" + '?$select=LogicalName'
        $null = Invoke-DvRequest -Method GET -RelativePath $path
        return $true
    }
    catch {
        $status = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = [int]$_.Exception.Response.StatusCode
        }

        if ($status -eq 404) {
            return $false
        }

        throw
    }
}

function Test-ColumnExists {
    param(
        [Parameter(Mandatory = $true)][string]$TableLogicalName,
        [Parameter(Mandatory = $true)][string]$ColumnLogicalName
    )

    try {
        $path = "EntityDefinitions(LogicalName='$TableLogicalName')/Attributes(LogicalName='$ColumnLogicalName')" + '?$select=LogicalName'
        $null = Invoke-DvRequest -Method GET -RelativePath $path
        return $true
    }
    catch {
        $status = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = [int]$_.Exception.Response.StatusCode
        }

        if ($status -eq 404) {
            return $false
        }

        throw
    }
}

function Ensure-Publisher {
    $publisher = Get-OneByUniqueName -EntitySet "publishers" -UniqueName $PublisherUniqueName -Select "publisherid,customizationprefix,customizationoptionvalueprefix"

    if ($publisher) {
        if ($publisher.customizationprefix -ne $PublisherPrefix) {
            throw "Publisher '$PublisherUniqueName' already exists with prefix '$($publisher.customizationprefix)', expected '$PublisherPrefix'."
        }

        Write-Host "Publisher exists: $PublisherUniqueName"
        return $publisher
    }

    Write-Host "Creating publisher: $PublisherUniqueName"

    $body = @{
        friendlyname = "Power Platform Performance Lab Publisher"
        uniquename = $PublisherUniqueName
        description = "Publisher for the public Power Platform Performance Lab."
        customizationprefix = $PublisherPrefix
        customizationoptionvalueprefix = $OptionValuePrefix
    }

    $null = Invoke-DvRequest -Method POST -RelativePath "publishers" -Body $body

    return Get-OneByUniqueName -EntitySet "publishers" -UniqueName $PublisherUniqueName -Select "publisherid,customizationprefix,customizationoptionvalueprefix"
}

function Ensure-Solution {
    param([Parameter(Mandatory = $true)][guid]$PublisherId)

    $solution = Get-OneByUniqueName -EntitySet "solutions" -UniqueName $SolutionUniqueName -Select "solutionid,uniquename,version"

    if ($solution) {
        Write-Host "Solution exists: $SolutionUniqueName"
        return $solution
    }

    Write-Host "Creating solution: $SolutionUniqueName"

    $body = @{
        friendlyname = "Power Platform Performance Lab"
        uniquename = $SolutionUniqueName
        description = "Reusable, anonymous benchmark harness for Power Apps, Power Fx, Dataverse, and Power Automate."
        version = "1.0.0.0"
        "publisherid@odata.bind" = "publishers($PublisherId)"
    }

    $null = Invoke-DvRequest -Method POST -RelativePath "solutions" -Body $body

    return Get-OneByUniqueName -EntitySet "solutions" -UniqueName $SolutionUniqueName -Select "solutionid,uniquename,version"
}

function Ensure-Table {
    param(
        [Parameter(Mandatory = $true)][string]$SchemaName,
        [Parameter(Mandatory = $true)][string]$LogicalName,
        [Parameter(Mandatory = $true)][string]$DisplayName,
        [Parameter(Mandatory = $true)][string]$DisplayCollectionName,
        [Parameter(Mandatory = $true)][string]$Description
    )

    if (Test-TableExists -LogicalName $LogicalName) {
        Write-Host "Table exists: $LogicalName"
        return
    }

    Write-Host "Creating table: $LogicalName"

    $primaryNameSchema = "${PublisherPrefix}_Name"

    $body = @{
        "@odata.type" = "Microsoft.Dynamics.CRM.EntityMetadata"
        SchemaName = $SchemaName
        DisplayName = New-LocalizedLabel $DisplayName
        DisplayCollectionName = New-LocalizedLabel $DisplayCollectionName
        Description = New-LocalizedLabel $Description
        OwnershipType = "OrganizationOwned"
        IsActivity = $false
        HasActivities = $false
        HasNotes = $false
        Attributes = @(
            @{
                "@odata.type" = "Microsoft.Dynamics.CRM.StringAttributeMetadata"
                AttributeType = "String"
                AttributeTypeName = @{ Value = "StringType" }
                SchemaName = $primaryNameSchema
                DisplayName = New-LocalizedLabel "Name"
                Description = New-LocalizedLabel "Synthetic benchmark record name."
                IsPrimaryName = $true
                RequiredLevel = New-RequiredLevelNone
                FormatName = @{ Value = "Text" }
                MaxLength = 200
            }
        )
    }

    $null = Invoke-DvRequest -Method POST -RelativePath "EntityDefinitions" -Body $body -SolutionScoped
}

function Ensure-StringColumn {
    param(
        [Parameter(Mandatory = $true)][string]$TableLogicalName,
        [Parameter(Mandatory = $true)][string]$SchemaName,
        [Parameter(Mandatory = $true)][string]$DisplayName,
        [int]$MaxLength = 200
    )

    $logicalName = $SchemaName.ToLowerInvariant()
    if (Test-ColumnExists -TableLogicalName $TableLogicalName -ColumnLogicalName $logicalName) {
        Write-Host "Column exists: $TableLogicalName.$logicalName"
        return
    }

    Write-Host "Creating string column: $TableLogicalName.$logicalName"

    $body = @{
        "@odata.type" = "Microsoft.Dynamics.CRM.StringAttributeMetadata"
        AttributeType = "String"
        AttributeTypeName = @{ Value = "StringType" }
        SchemaName = $SchemaName
        DisplayName = New-LocalizedLabel $DisplayName
        Description = New-LocalizedLabel "Synthetic performance-lab field."
        RequiredLevel = New-RequiredLevelNone
        FormatName = @{ Value = "Text" }
        MaxLength = $MaxLength
    }

    $path = "EntityDefinitions(LogicalName='$TableLogicalName')/Attributes"
    $null = Invoke-DvRequest -Method POST -RelativePath $path -Body $body -SolutionScoped
}

function Ensure-MemoColumn {
    param(
        [Parameter(Mandatory = $true)][string]$TableLogicalName,
        [Parameter(Mandatory = $true)][string]$SchemaName,
        [Parameter(Mandatory = $true)][string]$DisplayName,
        [int]$MaxLength = 4000
    )

    $logicalName = $SchemaName.ToLowerInvariant()
    if (Test-ColumnExists -TableLogicalName $TableLogicalName -ColumnLogicalName $logicalName) {
        Write-Host "Column exists: $TableLogicalName.$logicalName"
        return
    }

    Write-Host "Creating memo column: $TableLogicalName.$logicalName"

    $body = @{
        "@odata.type" = "Microsoft.Dynamics.CRM.MemoAttributeMetadata"
        AttributeType = "Memo"
        AttributeTypeName = @{ Value = "MemoType" }
        SchemaName = $SchemaName
        DisplayName = New-LocalizedLabel $DisplayName
        Description = New-LocalizedLabel "Synthetic performance-lab payload or notes."
        RequiredLevel = New-RequiredLevelNone
        Format = "TextArea"
        ImeMode = "Disabled"
        MaxLength = $MaxLength
        IsLocalizable = $false
    }

    $path = "EntityDefinitions(LogicalName='$TableLogicalName')/Attributes"
    $null = Invoke-DvRequest -Method POST -RelativePath $path -Body $body -SolutionScoped
}

function Ensure-IntegerColumn {
    param(
        [Parameter(Mandatory = $true)][string]$TableLogicalName,
        [Parameter(Mandatory = $true)][string]$SchemaName,
        [Parameter(Mandatory = $true)][string]$DisplayName,
        [int]$MinValue = 0,
        [int]$MaxValue = 2147483647
    )

    $logicalName = $SchemaName.ToLowerInvariant()
    if (Test-ColumnExists -TableLogicalName $TableLogicalName -ColumnLogicalName $logicalName) {
        Write-Host "Column exists: $TableLogicalName.$logicalName"
        return
    }

    Write-Host "Creating integer column: $TableLogicalName.$logicalName"

    $body = @{
        "@odata.type" = "Microsoft.Dynamics.CRM.IntegerAttributeMetadata"
        AttributeType = "Integer"
        AttributeTypeName = @{ Value = "IntegerType" }
        SchemaName = $SchemaName
        DisplayName = New-LocalizedLabel $DisplayName
        Description = New-LocalizedLabel "Synthetic performance-lab numeric field."
        RequiredLevel = New-RequiredLevelNone
        MaxValue = $MaxValue
        MinValue = $MinValue
        Format = "None"
        SourceTypeMask = 0
    }

    $path = "EntityDefinitions(LogicalName='$TableLogicalName')/Attributes"
    $null = Invoke-DvRequest -Method POST -RelativePath $path -Body $body -SolutionScoped
}

Write-Host "Target environment: $EnvironmentUrl"
Write-Host "Solution: $SolutionUniqueName"
Write-Host "Publisher prefix: $PublisherPrefix"

$publisher = Ensure-Publisher
$solution = Ensure-Solution -PublisherId ([guid]$publisher.publisherid)

Ensure-Table -SchemaName "${PublisherPrefix}_BenchmarkRecord" -LogicalName "${PublisherPrefix}_benchmarkrecord" -DisplayName "Benchmark Record" -DisplayCollectionName "Benchmark Records" -Description "Synthetic records used only for repeatable Power Platform performance experiments."

$recordTable = "${PublisherPrefix}_benchmarkrecord"
Ensure-StringColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_ExternalKey" -DisplayName "External Key" -MaxLength 100
Ensure-StringColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_DatasetTag" -DisplayName "Dataset Tag" -MaxLength 100
Ensure-StringColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_BusinessUnitCode" -DisplayName "Business Unit Code" -MaxLength 50
Ensure-StringColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_Category" -DisplayName "Category" -MaxLength 100
Ensure-StringColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_Status" -DisplayName "Status" -MaxLength 50
Ensure-IntegerColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_SequenceNumber" -DisplayName "Sequence Number"
Ensure-IntegerColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_SortKey" -DisplayName "Sort Key"
Ensure-IntegerColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_IsSelected" -DisplayName "Is Selected" -MinValue 0 -MaxValue 1
Ensure-MemoColumn -TableLogicalName $recordTable -SchemaName "${PublisherPrefix}_PayloadText" -DisplayName "Payload Text" -MaxLength 4000

Ensure-Table -SchemaName "${PublisherPrefix}_BenchmarkRun" -LogicalName "${PublisherPrefix}_benchmarkrun" -DisplayName "Benchmark Run" -DisplayCollectionName "Benchmark Runs" -Description "Sanitized measurements and validation results for one benchmark execution."

$runTable = "${PublisherPrefix}_benchmarkrun"
Ensure-StringColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_CorrelationId" -DisplayName "Correlation ID" -MaxLength 100
Ensure-StringColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_BenchmarkId" -DisplayName "Benchmark ID" -MaxLength 20
Ensure-StringColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_Pattern" -DisplayName "Pattern" -MaxLength 100
Ensure-IntegerColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_DatasetSize" -DisplayName "Dataset Size"
Ensure-IntegerColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_RunNumber" -DisplayName "Run Number"
Ensure-IntegerColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_DurationMs" -DisplayName "Duration (ms)"
Ensure-IntegerColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_RecordsReturned" -DisplayName "Records Returned"
Ensure-IntegerColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_RequestCount" -DisplayName "Request Count"
Ensure-StringColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_Outcome" -DisplayName "Outcome" -MaxLength 30
Ensure-StringColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_EvidenceLevel" -DisplayName "Evidence Level" -MaxLength 10
Ensure-MemoColumn -TableLogicalName $runTable -SchemaName "${PublisherPrefix}_Notes" -DisplayName "Notes" -MaxLength 4000

Write-Host "Publishing customizations..."
$null = Invoke-DvRequest -Method POST -RelativePath "PublishAllXml" -Body @{}

Write-Host ""
Write-Host "Bootstrap completed."
Write-Host "Solution ID: $($solution.solutionid)"
Write-Host "Tables:"
Write-Host "  - $recordTable"
Write-Host "  - $runTable"
