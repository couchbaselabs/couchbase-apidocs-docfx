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

var opts = new DotnetApiOptions()
{
    IncludeApi = (s) =>
    {
        Console.Out.WriteLine($"API={s.Name}, ({s.ContainingNamespace?.Name})");
        return s switch
        {
            { Name: "get_PartialDefinitionPart" } => SymbolIncludeState.Exclude,
            _ => SymbolIncludeState.Default
        };
    },
    IncludeAttribute = (s) =>
    {
        Console.Out.WriteLine($"Attribute={s.Name}");
        return SymbolIncludeState.Default;
    },
};

try
{
    await Docfx.Dotnet.DotnetApiCatalog.GenerateManagedReferenceYamlFiles(absolutePath, opts);
    await Docfx.Docset.Build(absolutePath);
}
catch (Exception e)
{
    Console.WriteLine(e);
    throw;
}
