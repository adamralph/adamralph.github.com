---

layout: post
title: NDC Diary - Day 3
location: London
tags:
- NDC
---

The incrementation of hangover severity continued this morning after [@stack72](https://twitter.com/stack72) dragged everyone to Shoreditch last night and [@JakeGinnivan](https://twitter.com/JakeGinnivan) introduced me to 35% beer. A great night all round.<!--excerpt-->

![Nancy stickers... everywhere](/img/nancy-stickers-everywhere.jpg)

The prize for sticker bombing goes to [@randompunter](https://twitter.com/randompunter) ([@NancyFx](https://twitter.com/NancyFx)) with [@roysvork](https://twitter.com/roysvork) ([Superscribe](http://superscribe.org/)) the runner up.

### Recording a .NET Rocks! show with [Glenn Block](https://twitter.com/gblock) and [Justin Rusbatch](https://twitter.com/jrusbatch)

Glenn and Justin were kind enough to invite me to join them this morning in recording a show about [scriptcs](http://scriptcs.net/) for [.NET Rocks!](http://www.dotnetrocks.com/) with [Richard Campbell](https://twitter.com/richcampbell) and [Carl Franklin](https://twitter.com/carlfranklin). We had a lot of fun recording the show and I hope I managed to add something useful. Look out for the show at [.NET Rocks!](http://www.dotnetrocks.com/) in early January.

### The Future of C# with Mads Torgersen

The NDC Wi-Fi was put to the test during this talk with the C# Twitter stream seeing an explosion in traffic as Mads revealed, for the first time publicly, a range of features either set to be delivered in the next version of C# or at least under strong consideration.

Unfortunately I was too caught up in the excitement to note everything down but after mining my memory and the Twitter feed, here is the list of implemented/potential language features (I'm sure I'm missing at least one of them):

* primary constructors - `public class Point(int x, int y) { }`
* read only auto-properties - `public int X { get; } = x;`
* static type using statements - `using System.Math;`
* property expressions - `public double Distance => Sqrt(X * X + Y * Y);`
* method expressions - `public Point Move(int dx, int dy) => new Point(X + dx, Y + dy);`
* params for enumerable types - `public Point Average(params IEnumerable<Point> points) { }`
* monadic null checking - `if (points?.FirstOrDefault()?.X ?? -1) { }`
* constructor type parameter inference - `var t = new Tuple(1,2); // infers Tuple<T1, T2>`
* inline declarations for out params - `public void Foo(out var x, out var y) { }`

I love all these features perhaps with the exception of the last one. Whist it doesn't negatively effect the language (although some of the audience were concerned about encouraging the use of `out` parameters) it doesn't really do much to achieve the stated goal of improving syntax for multiple return values. I was hoping for something like:

```C#
public (int x, int y) Foo() { }
```

But still, the rest of the features look awesome and I can't wait to get my hands on C# vNext!

### NodeJS vs C# Cage Match with [Rob Ashton](https://twitter.com/RobAshton) and [Jeremy Miller](https://twitter.com/jeremydmiller)

Rob spun my head as usual. Jeremy quietly impressed me. I didn't understand much of what Rob did, but I'm sure he doesn't care. He seemed to be enjoying himself.

Jeremy's work in FubuMVC to give it a Rails-like management system using Rake is impressive and shows just what Rake can do when put to work. This was particularly interesting for me since I've recently started work on a C# Rake equivalent named [Bau](https://github.com/bau-build/bau), based on Roslyn and scriptcs. If I can get Bau to the level where it could potentially be used for FubuMVC instead of Rake that would be quite an achievement and has definitely given me something to aim for.

### SignalR with [Damian Edwards](https://twitter.com/DamianEdwards) and [David Fowler](https://twitter.com/davidfowl)

The dynamic duo took centre stage again and didn't fail to impress with another whirlwind live coding tour of the huge capabilities of SignalR, including a nice little off-script foray by David into Nancy hosted with nowin. Equally impressive was the way Damian and David seemed to have bravely shrugged off the embarrassment suffered at the pool table at the hands of [@jchannon](https://twitter.com/jchannon) and myself just two days earlier.

### scriptcs with [Justin Rusbatch](https://twitter.com/jrusbatch)

And the holy trinity is finally complete. I'm now one of the lucky few that has seen scriptcs presented by all three of the owners independently.

One thing that really stood out in Justin's talk was how *blazingly fast* he had scriptcs running in his demos. I couldn't help asking about this during the talk and it turns out Justin completely threw the rule book out of the window and compiled a custom version of scriptcs right before his talk with some new compiler switches introduced in .NET 4.5. Wow, this is the definition of courage! I can't wait to see those compiler switches make it into the published package.  

### NDC London: The Conclusion

What a week. Remember those times you went on holiday as a child and you never wanted it to end? That's me right now. NDC London was my first conference and the decision to attend was one of the best I've made in a while.

Would I recommend it to others? Definitely. Will I be back? Yes. Where and when? Next year in Oslo. My biggest takeaway from the conference? All the awesome people I met, many of whom I've chatted and coded with virtually but never before met in person and others I've admired and followed over the years and was honoured to finally meet in person. And with that I leave you with my complete 'names to faces checklist', collected each day to show just how many great people you can meet at an event like the NDC. Bye bye NDC London. Hello NDC Oslo...


Until next time (apologies to anyone I've missed):
[@mat_mcloughlin](https://twitter.com/mat_mcloughlin) [@venkat_s](https://twitter.com/venkat_s) [@jezhumble](https://twitter.com/jezhumble) [@randompunter](https://twitter.com/randompunter) [@jrusbatch](https://twitter.com/jrusbatch) [@roysvork](https://twitter.com/roysvork) [@stevensanderson](https://twitter.com/stevensanderson) [@serialseb](https://twitter.com/serialseb) [@darrel_miller](https://twitter.com/darrel_miller) [@shiftkey](https://twitter.com/shiftkey) [@JakeGinnivan](https://twitter.com/JakeGinnivan) [@Ben_Hall](https://twitter.com/Ben_Hall) [@chrissie1](https://twitter.com/chrissie1) [@jchannon](https://twitter.com/jchannon) [@Cranialstrain](https://twitter.com/Cranialstrain) [@gblock](https://twitter.com/gblock) [@jonskeet](https://twitter.com/jonskeet) [@dhelper](https://twitter.com/dhelper) [@stack72](https://twitter.com/stack72) [@paulcbetts](https://twitter.com/paulcbetts) [@davidfowl](https://twitter.com/davidfowl) [@DamianEdwards](https://twitter.com/DamianEdwards) [Mads Torgensen](https://www.google.co.uk/search?q=mads+torgensen) [@scottgu](https://twitter.com/scottgu) [@unclebobmartin](https://twitter.com/unclebobmartin) [@BrockLAllen](https://twitter.com/BrockLAllen) [@citizenmatt](https://twitter.com/citizenmatt) [@RemoGloor](https://twitter.com/RemoGloor) [@richcampbell](https://twitter.com/richcampbell) [@carlfranklin](https://twitter.com/carlfranklin)