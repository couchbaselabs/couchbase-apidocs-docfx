[CmdletBinding()]
param(
    # the folder containing DocFx.json
    [Parameter(Mandatory=$true)]
    [string]
    $DocfxProjectFolder,

    # The API version you are building docs for (e.g. 3.1.5)
    [Parameter(Mandatory=$true)]
    [string]
    $ApiVersion,

    # Host a websit for the generated docs on port 8080
    [switch]
    $Serve,

    # Create a .zip file of the output.
    [string]
    $ZipOutput = $null,

    [string]
    $SrcFolderOverride = $null
)

$ErrorActionPreference = "STOP"
$DocfxProjectFile = "$DocfxProjectFolder/docfx.json"

# if docfx updates to an incompatible version, try adding --version 2.77.0 --allow-downgrade
dotnet tool install -g docfx

# Set the _appTitle to the API Version (see also: _appName in docfx.json)
# Update the copyright notice to the current year.
$year = (Get-Date).Year
$overrides = [PSCustomObject]@{
    _appTitle = $ApiVersion;
    _appFooter = "&copy; $year Couchbase, Inc."
}

$overrides | ConvertTo-Json | Out-File "$DocfxProjectFolder/overrides.json" -Encoding utf8

if ($SrcFolderOverride) {
    $origContent = Get-Content $DocfxProjectFile
    $json = $origContent | ConvertFrom-Json
    $json
    $curSrc = $json.metadata[0].src.src
    $srcFolder = Get-Item $SrcFolderOverride
    Push-Location $DocfxProjectFolder
    $relativeSrcFolder = $srcFolder | Resolve-Path -Relative
    Pop-Location
    Write-Host "$relativeSrcFolder vs. $curSrc"
    $relativeSrcFolder = $relativeSrcFolder -replace "\\","/"
    $newContent = $origContent -replace $curSrc, $relativeSrcFolder
    $newContent | Out-File $DocfxProjectFile -Encoding utf8
}

if ($Serve) {
    docfx $DocfxProjectFile --serve
}
else {
    docfx $DocfxProjectFile
}

if ($ZipOutput) {
    Compress-Archive -Path $DocfxProjectFolder/_site -DestinationPath $ZipOutput
}