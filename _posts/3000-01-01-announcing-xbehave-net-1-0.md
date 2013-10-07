---

layout: post
title: Announcing xBehave.net 1.0
location: Zurich
tags:
- xbehave.net
published: false
---

![](https://raw.github.com/xbehave/xbehave.net/master/assets/xbehave_128x128.png)

It gives me great pleasure to announce the release today of [xBehave.net](http://xbehave.github.io/) [1.0](https://www.nuget.org/packages/Xbehave/1.0.0).

This is the first stable release of xBehave.net after more than 18 months of (sporadic) initial development.

Extensive documentation is also now available on the xBehave.net [wiki](https://github.com/xbehave/xbehave.net/wiki).

<!--excerpt-->

## Thanks ##

By far the most important aspect of xBehave.net is **you**, the community. Thank you for all the contribution, usage, suggestion, bug discovery, criticism and discussion. It has made xBehave.net what it is today. Please continue so xBehave.net can continue to evolve as we do.

In particular, I'd like to thank the following developers for their contributions to xBehave.net 1.0:

- [Glenn Block](https://github.com/glennblock)
- [James Foster](https://github.com/jamesfoster)
- [Manoj](https://github.com/manojlds)
- [robi-y](https://github.com/robi-y)

## History ##

The roots of xBehave.net go back to August 2008 in a spike by [Phil Haack](http://haacked.com/) and [Brad Wilson](http://bradwilson.typepad.com/) named [SubSpec](http://haacked.com/archive/2008/08/23/introducing-subspec.aspx), aimed at showcasing the extensibility of [xUnit.net](https://xunit.codeplex.com/).

The idea was rekindled in August 2010 by [Johannes Rudolph](http://jorudolph.wordpress.com/) when he created the [SubSpec](https://bitbucket.org/johannesrudolph/subspec) project, later published on [NuGet](https://www.nuget.org/packages/SubSpec/).

In January 2012, [Cameron Fletcher](http://cameronfletcher.com/) introduced the original SubSpec spike to a project we were working on. Although I'd previously read Phil Haack's post, I'd never tried the code until then. I immediately liked it and, having already used [Cucumber](http://cukes.info/) with Ruby, I soon stumbled upon the idea of introducing a Given, When, Then syntax to the library.

Soon afterwards I discovered and forked Johannes Rudolph's SubSpec project and created [SubSpecGWT](https://bitbucket.org/adamralph/subspecgwt) which I pushed to [NuGet](https://www.nuget.org/packages/SubSpecGWT) in early February 2012.

After a month of development and a few more releases, I re-branded the project as xBehave.net and pushed the [first release](https://www.nuget.org/packages/Xbehave/0.7.0) to NuGet at the end of February 2012.

Over the next 18 months the library became richer and more polished and gained a few contributors in the march up to 1.0.

After a little [tweeting](https://twitter.com/gblock/status/338899543821262849) in May 2013 [Glenn Block](https://twitter.com/gblock) decided to use xBehave.net for acceptance test examples in his forthcoming book ['Designing Evolvable Web APIs with ASP.NET'](http://ofps.oreilly.com/titles/9781449337711/).

## Future ##

The next planned version is 2.0 which will see a transition from xUnit.net 1.9 to xUnit.net 2.0 (currently in alpha) and [several enhancements](https://github.com/xbehave/xbehave.net/issues?labels=enhancement&page=1&state=open).

1.0 has entered maintenance mode with bug fix releases only. All new features will be scheduled for 2.0 or later.

Internally, the changes in 2.0 will be significant. xUnit.net 2.0 is more or less a complete re-write, which means xBehave.net 2.0 is likely to be the same.

If you'd like to help out, just head over to the [GitHub](https://github.com/xbehave/xbehave.net/) repository where you can get familiar with the code, send pull requests or raise issues for new features, bugs, questions, discussions etc.

You can also ping me on [Twitter](https://twitter.com/adamralph) or in the xBehave.net [chat room](https://jabbr.net/#/rooms/xbehavenet) in JabbR.

**Thanks again!**