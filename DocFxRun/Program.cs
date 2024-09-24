// See https://aka.ms/new-console-template for more information


using Docfx.Dotnet;

if (args is not { Length: > 0 })
{
    Console.WriteLine("Usage: DocFxRun path/to/docfx.json");
    Environment.ExitCode = 1;
    return;
}

var pathToDocfxProjectJson = args[0];
var absolutePath = Path.GetFullPath(pathToDocfxProjectJson);

if (!File.Exists(absolutePath))
{
    Console.Error.WriteLine($"File '{absolutePath}' does not exist.");
    Environment.ExitCode = 2;
    return;
}

try
{
    await Docfx.Dotnet.DotnetApiCatalog.GenerateManagedReferenceYamlFiles(absolutePath);
    await Docfx.Docset.Build(absolutePath);
}
catch (Exception e)
{
    Console.WriteLine(e);
    throw;
}
