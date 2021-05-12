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
    $ZipOutput = $null
)

$DocfxProjectFile = "$DocfxProjectFolder/docfx.json"

# use NuGet restore to a local path to get the appropraite docfx.console package
mkdir nupkgs -ErrorAction Ignore
dotnet restore $DocfxProjectFolder/docfx.csproj --force --packages ./nupkgs

Set-Alias docfx "./nupkgs/docfx.console/2.57.2/tools/docfx.exe"

# Set the _appTitle to the API Version (see also: _appName in docfx.json)
# Update the copyright notice to the current year.
$year = (Get-Date).Year
$overrides = [PSCustomObject]@{
    _appTitle = $ApiVersion;
    _appFooter = "&copy; $year Couchbase, Inc."
}

$overrides | ConvertTo-Json | Out-File "$DocfxProjectFolder/overrides.json" -Encoding utf8NoBOM

if ($Serve) {
    docfx $DocfxProjectFile --serve
}
else {
    docfx $DocfxProjectFile
}

if ($ZipOutput) {
    Compress-Archive -Path $DocfxProjectFolder/_site -DestinationPath $ZipOutput
}