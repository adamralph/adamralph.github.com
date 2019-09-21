---

layout: post
title: Announcing xBehave.net 2.0
location: Zurich
tags:
- testing
- xBehave.net
- releases
---

I'm enormously happy to announce that [xBehave.net 2.0](http://xbehave.github.io/) (based on [xUnit.net 2.0](http://xunit.github.io/)) is now live and available on [NuGet](https://www.nuget.org/packages/Xbehave/2.0.0). Work on xBehave.net 2.0 began in April 2014, shortly after the first beta release of xUnit.net 2.0, and continued on and off for the next 16 months with the first xBehave.net 2.0 beta release in December.<!--excerpt-->

![](https://raw.github.com/xbehave/xbehave.net/master/assets/xbehave_128x128.png)

Just like xUnit.net 2.0, xBehave.net 2.0 is a complete re-write from scratch, with only the public API type names and method signatures remaining relatively unchanged. However, only 'half' of the code base was in fact re-written. xBehave.net has dogfooded itself for it's own acceptance tests since pre-1.0, and those acceptance tests have remained largely as is and only added to, throughout the whole exercise. This meant that xBehave.net 2.0 was developed almost entirely in true TDD style. The suite of 1.x acceptance tests already existed. All that needed to be done was to create a project linked against xUnit.net 2.0 which made those tests green!

Linking against xUnit.net 2.0 is not the only change in xBehave.net 2.0. Several new features have been added (and, of course accompanying acceptance tests), some changed and some taken away. For full details, see the [Wiki](https://github.com/xbehave/xbehave.net/wiki/Changes-in-version-2.0).

### Thanks ##

[As I've said before](/2013/10/09/announcing-xbehave-net-1-0/), by far the most important aspect of xBehave.net is **you**, the community. In particular, I'd like to call out the following people for their invaluable help in getting xBehave.net 2.0 out of the door:

#### [Brad Wilson](https://github.com/bradwilson)

Brad gave me a horde of advice and assistance over at the [xUnit.net chat room](https://xunit.slack.com/messages/general/details/) and made a slew of changes to xUnit.net 2.0 during the beta phase which allowed xBehave.net 2.0 to come into existence. Not least, the split of the component packages into meta packages and \*.extensibility.\* packages. Thank you Brad for embracing the community during the development of xUnit.net 2.0 and for one of the most elegantly designed extensibility API's this developer has ever had the pleasure to use!

#### [Matt Ellis](https://github.com/citizenmatt)

During smoke testing with the [ReSharper](https://www.jetbrains.com/resharper/) xUnit.net plug-in, I discovered some problems in the beta versions of both xBehave.net and the ReSharper plug-in. I was lucky enough to able to collaborate closely with Matt in the xUnit.net chat room, resulting in a cross-pollination of improvement and fixes to both products.

#### [Remco Mulder](https://github.com/remcomulder)

During smoke testing with a pre-release version of [NCrunch](http://www.ncrunch.net/) linked against the xUnit.net 2.0 betas, I discovered some problems in both NCrunch and xBehave.net. Remco spent a large amount of time with me in the xUnit.net chat room reproducing and identifying these problems and, together, we fixed the problems on either side of the integration until we got to a point where xBehave.net was crunching along nicely with NCrunch.

#### [Urs Enzler](https://github.com/ursenzler)

Urs gave me some enormously valuable feedback as a user of xBehave.net during the release candidate phase. Not least, he drove the split of the package into a meta package plus a core implementation package, to allow developers who do not want to take a dependency on xunit.assert to install the Xbehave.Core package instead of Xbehave, similarly to the xunit and xunit.core packages. Urs also presented the ideas which inspired the creation of the [continuing on failure](https://github.com/xbehave/xbehave.net/wiki/Continuing-on-failure) and [step filters](https://github.com/xbehave/xbehave.net/wiki/Step-filters) features. BTW, if you're interested in generating Markdown output from your xBehave.net tests, check out his [xBehaveMarkdownReport ](https://github.com/ursenzler/xBehaveMarkdownReport) tool.

### Future

The next planned version of xBehave.net is 2.1, which will be linked against xUnit.net 2.1 (currently in beta), and will add support for the 'dotnet' (vNext, DNX, .NET Core, etc.) NuGet TFN.

If you'd like to help out, just head over to the [GitHub repository](https://github.com/xbehave/xbehave.net/) where you can get familiar with the code, send pull requests or raise issues for new features, bugs, questions, discussions etc.

You can also ping me on [Twitter](https://twitter.com/adamralph) or in the xBehave.net [chat room](https://jabbr.net/#/rooms/xbehavenet) on JabbR.

**Thanks again!**
