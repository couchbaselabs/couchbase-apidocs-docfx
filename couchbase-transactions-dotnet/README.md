== DocFx API Documentation projects for Couchbase .NET SDKs and Extensions ==

1. `git clone` this repository
2. `git clone` the desired Couchbase SDK repository such as `couchbase-net-client` as the same level
3. Run the powershell script to generate the documentation
* * `.\Generate-ApiDocs.ps1 .\couchbase-net-client\ -ApiVersion <ApiVersionTag> -Serve -ZipOutput couchbaset-net-client-<ApiVersionTag>.zip`
4. Preview on http://localhost:8080 (omit the `-Serve` parameter to skip this step)

Note: the generated output must be hosted over http:// or https://, and will not display correctly with file:// previews.