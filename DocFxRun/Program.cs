// See https://aka.ms/new-console-template for more information


if (args is not { Length: > 0 })
{
    Console.WriteLine("Usage: DocFxRun path/to/docfx.json");
    Environment.ExitCode = 1;
    return;
}

var pathToDocfxProjectJson = args[0];

if (!File.Exists(pathToDocfxProjectJson))
{
    var absolutePath = Path.GetFullPath(pathToDocfxProjectJson);
    Console.Error.WriteLine($"File '{absolutePath}' does not exist.");
    Environment.ExitCode = 2;
    return;
}

await Docfx.Docset.Build(pathToDocfxProjectJson);