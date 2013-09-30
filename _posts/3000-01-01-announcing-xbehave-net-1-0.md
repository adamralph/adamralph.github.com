---

layout: post
title: Announcing xBehave.net 1.0
location: Zurich
tags:
- xbehave.net
published: false
---

![](https://raw.github.com/xbehave/xbehave.net/master/assets/xbehave_128x128.png)

It gives me great to pleasure to announce today's release of [xBehave.net](http://xbehave.github.io/) version [1.0](https://www.nuget.org/packages/Xbehave/1.0.0). Extensive documentation is also now available in the [xBehave.net wiki on GitHub](https://github.com/xbehave/xbehave.net/wiki).

This is the first stable release of xBehave.net, after more than 18 months of (sporadic) initial development.

<!--excerpt-->

## Thanks ##

By far the most important aspect of xBehave.net is **you**, the community. Thank you for all the contributions, usage, suggestions, bug findings, criticism and discussion which has made xBehave.net what it is today. Please do continue, so that xBehave.net can continue to evolve as we do.

In particular, I'd like to thank the following developers for their contributions to xBehave.net 1.0:

- [Glenn Block](https://github.com/glennblock)
- [James Foster](https://github.com/jamesfoster)
- [Manoj](https://github.com/manojlds)
- [robi-y](https://github.com/robi-y)

## History ##

The roots of xBehave.net go all the way back to August 2008 in a spike by [Phil Haack](http://haacked.com/) and [Brad Wilson](http://bradwilson.typepad.com/) which they named [SubSpec](http://haacked.com/archive/2008/08/23/introducing-subspec.aspx), with the aim of showcasing the extensibility of [xUnit.net](https://xunit.codeplex.com/).

The idea was picked up again 2 years later in August 2010 by [Johannes Rudolph](http://jorudolph.wordpress.com/), who created the [SubSpec](https://bitbucket.org/johannesrudolph/subspec) project and later published it as  a [NuGet package](https://www.nuget.org/packages/SubSpec/) in May 2011.

In January 2012, I was introduced to Phil Haack's original SubSpec code sample by [Cameron Fletcher](http://cameronfletcher.com/). Although I'd already read Phil Haack's blog post, I'd never tried out the approach myself. I immediately liked it and, having already used [Cucumber](http://cukes.info/) with Ruby, I soon stumbled upon the idea of introducing a Given, When, Then syntax to the library.

I decided to fork SubSpec and create [SubSpecGWT](https://bitbucket.org/adamralph/subspecgwt) which I pushed out as a [NuGet package](https://www.nuget.org/packages/SubSpecGWT) in early February 2012.

After a month of development and a few more releases, I decided to re-brand the project as xBehave.net and pushed out the [first release](https://www.nuget.org/packages/Xbehave/0.7.0) to NuGet at the end of February 2012.

Over the next 18 months, the library became richer and more polished, gained a few contributors and, in June 2013, I was contacted by [Glenn Block](https://twitter.com/gblock) who decided to use xBehave.net for acceptance test examples in his forthcoming book ['Designing Evolvable Web APIs with ASP.NET'](http://ofps.oreilly.com/titles/9781449337711/).

## Future ##

The next phase of evolution for xBehave.net will be the transition from xUnit.net 1.9 to xUnit.net 2.0, which is currently under development.

The core xBehave.net 2.0 features are expected to be similar to 1.0 with [several enhancements](https://github.com/xbehave/xbehave.net/issues?labels=enhancement&page=1&state=open) already on the drawing board.

xBehave.net 1.0 has now entered maintenance mode with bug fix releases only. All new features will be scheduled for version 2.0.

Internally, the changes will be significant. xUnit.net 2.0 is more or less a complete re-write, which means xBehave.net 2.0 is likely to be the same.

If you'd like to help out, just head over to the [GitHub](https://github.com/xbehave/xbehave.net/) repository where you can get familiar with the code, send pull requests or raise issues for new features, bugs, questions, discussions etc. You can also ping me on [Twitter](https://twitter.com/adamralph) or in the xBehave.net [chat room](https://jabbr.net/#/rooms/xbehavenet) in JabbR.

**Thanks again!**