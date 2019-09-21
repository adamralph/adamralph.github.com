---
layout: post
title: How To Kill Your NuGet Package Through Casing
location: Flims
tags:
- NuGet
- OSS
---

When the initial placeholder for the [Bau.Xunit](https://www.nuget.org/packages/Bau.Xunit/) package was uploaded, the ID was cased `Bau.XUnit`. Later, when the first real package was uploaded, the ID was cased `Bau.Xunit`. Since the NuGet gallery compares IDs without case sensitivity, these ID were matched and hence the later package became a newer version of the older, but the original ID `Bau.XUnit` remained.<!--excerpt-->

This caused problems in Linux, since the folder on disk was created using the gallery ID `Bau.XUnit`, but the .csproj reference was added using the ID in the package version that has been downloaded, `Bau.Xunit`. Now, because Linux has a case sensitive file system, the reference did not point to the package on disk, and everything blew up when trying to compile the project. This is a bug in itself, but getting a NuGet client patch pushed out wasn't something I fancied pursuing at the time. This lead to some [horrible build hacks](https://github.com/bau-build/bau/blob/780bb643bd8ec16aab1daa7cc3f1add31084ef3f/bau.sh#L22-L26). So, I decided it was time to fix things once and for all, in the NuGet gallery...

The natural thing to do was to fix the ID in the gallery, since `Bau.Xunit` is the desired casing. The NuGet support staff where very helpful and, on my request, removed all the versions of the package from the gallery. I then re-uploaded all the correctly ID'd versions of the package and, hey presto, the casing was fixed and the ID of the package was `Bau.Xunit`. This is proven since the URL for the package, in search results, etc. was now "https://www.nuget.org/packages/Bau.Xunit/" instead of "https://www.nuget.org/packages/Bau.XUnit/". All good.

That is, until I tried to consume the package using the NuGet client. I received an error telling me

> Unable to find version '0.1.0-beta07' of package 'Bau.Xunit'.

So I dug further and spun up Fiddler to see what was going on behind the scenes. I found the following:

    REQUEST:
    --------------------------------
    GET https://www.nuget.org/api/v2/Packages(Id='Bau.Xunit',Version='0.1.0.0-beta07') HTTP/1.1
    DataServiceVersion: 1.0;NetFx
    MaxDataServiceVersion: 2.0;NetFx
    User-Agent: NuGet/2.8.50506.491 (Microsoft Windows NT 6.2.9200.0)
    Accept: application/atom+xml,application/xml
    Accept-Charset: UTF-8
    Host: www.nuget.org
    Accept-Encoding: gzip, deflate
    --------------------------------

    RESPONSE:
    --------------------------------
    HTTP/1.1 200 OK
    Cache-Control: no-cache
    Content-Length: 4153
    Content-Type: application/atom+xml;type=entry;charset=utf-8
    Server: Microsoft-IIS/8.0
    X-Content-Type-Options: nosniff
    DataServiceVersion: 2.0;
    X-AspNet-Version: 4.0.30319
    X-Powered-By: ASP.NET
    X-Frame-Options: deny
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    Strict-Transport-Security: maxage=31536000; includeSubDomains
    Date: Wed, 04 Mar 2015 21:52:17 GMT

    <?xml version="1.0" encoding="utf-8"?><entry xml:base="https://www.nuget.org/api/v2/" xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata"><id>https://www.nuget.org/api/v2/Packages(Id='Bau.XUnit',Version='0.1.0-beta07')</id><category term="NuGetGallery.V2FeedPackage" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme" /><link rel="edit" title="V2FeedPackage" href="Packages(Id='Bau.XUnit',Version='0.1.0-beta07')" /><title type="text">Bau.XUnit</title><summary type="text"></summary><updated>2014-12-01T21:51:40Z</updated><author><name>Adam Ralph,  Bau contributors</name></author><link rel="edit-media" title="V2FeedPackage" href="Packages(Id='Bau.XUnit',Version='0.1.0-beta07')/$value" /><content type="application/zip" src="https://www.nuget.org/api/v2/package/Bau.XUnit/0.1.0-beta07" /><m:properties><d:Version>0.1.0-beta07</d:Version><d:NormalizedVersion>0.1.0-beta07</d:NormalizedVersion><d:Copyright>Copyright (c) Bau contributors. (baubuildch@gmail.com)</d:Copyright><d:Created m:type="Edm.DateTime">2014-12-01T21:51:40.407</d:Created><d:Dependencies>ScriptCs.Contracts:0.9.0:|Bau:0.1.0-beta07:</d:Dependencies><d:Description>A Bau task plugin for running xUnit.net tests.

    Require&lt;Bau&gt;().Xunit().Do(xunit =&gt; xunit.UseExe("xunit.console.clr4.exe").RunAssemblies("Tests.dll")).Run();</d:Description><d:DownloadCount m:type="Edm.Int32">339</d:DownloadCount><d:GalleryDetailsUrl>https://www.nuget.org/packages/Bau.XUnit/0.1.0-beta07</d:GalleryDetailsUrl><d:IconUrl>https://raw.githubusercontent.com/bau-build/bau/dev/assets/bau.128.png</d:IconUrl><d:IsLatestVersion m:type="Edm.Boolean">false</d:IsLatestVersion><d:IsAbsoluteLatestVersion m:type="Edm.Boolean">true</d:IsAbsoluteLatestVersion><d:IsPrerelease m:type="Edm.Boolean">false</d:IsPrerelease><d:Language></d:Language><d:Published m:type="Edm.DateTime">2014-12-01T21:51:40.407</d:Published><d:PackageHash>8xLVSlIHbAgJ/BxwAhELOKYZZCKEnwP3IHRWHnvQyuen8gB0vONMdEuuuUoxfwhir6mK5dSPtst3baua3oARqA==</d:PackageHash><d:PackageHashAlgorithm>SHA512</d:PackageHashAlgorithm><d:PackageSize m:type="Edm.Int64">41098</d:PackageSize><d:ProjectUrl>https://github.com/bau-build/bau/tree/dev/src/Bau.Xunit</d:ProjectUrl><d:ReportAbuseUrl>https://www.nuget.org/package/ReportAbuse/Bau.XUnit/0.1.0-beta07</d:ReportAbuseUrl><d:ReleaseNotes></d:ReleaseNotes><d:RequireLicenseAcceptance m:type="Edm.Boolean">false</d:RequireLicenseAcceptance><d:Tags>xunit xbehave test tests tdd bdd C# build script task target runner rake grunt gulp fake nake jake psake sake</d:Tags><d:Title>Bau.Xunit</d:Title><d:VersionDownloadCount m:type="Edm.Int32">0</d:VersionDownloadCount><d:MinClientVersion></d:MinClientVersion><d:LastEdited m:type="Edm.DateTime" m:null="true" /><d:LicenseUrl>https://github.com/bau-build/bau/blob/dev/license.txt</d:LicenseUrl><d:LicenseNames></d:LicenseNames><d:LicenseReportUrl></d:LicenseReportUrl></m:properties></entry><?xml version="1.0" encoding="utf-8"?><m:error xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata"><m:code>500</m:code><m:message xml:lang="en-US">An error occurred while trying to write an error payload.</m:message><m:innererror><m:message>Cannot transition from state 'Completed' to state 'Error'. Nothing further can be written once the writer has completed.</m:message><m:type>Microsoft.Data.OData.ODataException</m:type><m:stacktrace>   at Microsoft.Data.OData.ODataWriterCore.Microsoft.Data.OData.IODataOutputInStreamErrorListener.OnInStreamError()&#xD;
       at Microsoft.Data.OData.Atom.ODataAtomOutputContext.WriteInStreamErrorImplementation(ODataError error, Boolean includeDebugInformation)&#xD;
       at Microsoft.Data.OData.Atom.ODataAtomOutputContext.WriteInStreamError(ODataError error, Boolean includeDebugInformation)&#xD;
       at System.Data.Services.ErrorHandler.WriteErrorWithFallbackForXml(ODataMessageWriter messageWriter, Encoding encoding, Stream responseStream, HandleExceptionArgs args, ODataError error, MessageWriterBuilder messageWriterBuilder)</m:stacktrace></m:innererror></m:error>
    --------------------------------


Clearly something was going horribly wrong when trying to request this package from the API.

Note that in the response, the package is referred to as `Bau.XUnit` which means that there are still traces of the old, incorrectly, cased package ID somewhere in the API.

So it seems like some parts of the system are referring to the package as `Bau.Xunit` (correct) and others are still referring to it as `Bau.XUnit` (incorrect). I suspect this is the root of the problem.

I've asked NuGet support to look into the problem since, as it stands, the Bau.Xunit package is completely out of action :scream:.

---
### Update

*05 Mar 2015*

I've [raised a bug](https://github.com/NuGet/NuGetGallery/issues/2379) on the NuGet Gallery GitHub repo to try and get some more eyes on this. Ultimately this ought to be fixed, but in the meantime I'm hoping some keen eyed developers can spot a workaround that could be done by the support team.

---
### Update

*05 Mar 2015*

Until the issue has been resolved, I've uploaded a temporary stand in package named [Bau.Xunit.Temp](https://www.nuget.org/packages/Bau.Xunit.Temp). You can switch your project to using this package whilst the saga continues.
