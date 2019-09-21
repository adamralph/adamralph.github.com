---

layout: post
title: NDC Diary - Day 1 
location: London
tags:
- NDC
---

After nursing a slight hangover inflicted by [@serialseb](https://twitter.com/serialseb)'s drinks night in Soho, I somehow managed to drag myself in well before 09:00 to finish off and push yesterday's diary entry before proceedings began.<!--excerpt-->

### Keynote - Jackstones: the Journey to Mastery with [Dan North](https://twitter.com/tastapod)

I really enjoyed Dan's talk. Although I'd commonly heard the term 'journeyman' before I'd never really known what it meant and today I found out. I also found out that the vast majority of people I deal with in the software development world (including myself), are themselves journeymen with, thankfully, a few apprentices thrown in here and there. I'd like to think I work with some masters too but my suspicion is that they are very few and far between. A really well delivered talk from Dan.

### GetEventStore with [Liam Westley](https://twitter.com/westleyl)

In may day job we use event sourcing heavily. Our typical data flow takes the form:

```
external client -> Nancy web API -> RabbitMQ -> command handler -> domain mutation -> domain event ->
NEventStore -> SQL Server -> RabbitMQ -> event handler -> read model view ->
MongoDB -> Nancy web API -> external client
```

After seeing [GetEventStore](http://geteventstore.com/) in action I can see how this could easily be reduced to:

```
external client -> Nancy web API -> RabbitMQ -> command handler -> domain mutation -> domain event ->
GetEventStore -> Nancy web API -> external client
```
I.e. the second line of our current flow could be removed completely.

A few people seemed to be expecting an explanation of what event sourcing is from this talk but I think Liam did the right thing and kept that out of it. The subject would have drowned the purpose of the talk which was to demonstrate GetEventStore and I think Liam did that well.

### scriptcs with [Glenn Block](https://twitter.com/gblock)

I've been quite involved in [scriptcs](http://scriptcs.net/), having contributed a little code and a few ideas to the project. I also own some OSS projects which are built over scriptcs ([ConfigR](https://github.com/config-r/config-r), [ScriptCs.Nancy](https://github.com/adamralph/scriptcs-nancy) and in very early stages - [Bau](https://github.com/bau-build/bau)).

Glenn is a confident and entertaining speaker which makes his talks really enjoyable. It was great to hear about scriptcs from another of the founding fathers, after seeing [@filip_woj](https://twitter.com/filip_woj) in action in Zurich earlier this year. After [@jrusbatch](https://twitter.com/jrusbatch)'s talk on Friday that will make a complete set. Unfortunately a nasty bite was taken out of Glen's talk with an internet connection problem, which Glen's talk relied on, so a bit of content had to be skipped and the demos were thrown a little off tack as a result but Glen dealt with it well and didn't let it spoil the talk.

### Hypermedia with [Darrel Miller](https://twitter.com/darrel_miller)

 The missing link(!) in most web API's is hypermedia. To paraphrase Roy Fielding, if you're not doing hypermedia then you're not doing REST. Hypermedia is not optional. Why is it missing? I think the main reason is that people conflate HTTP with REST and once they're serving stuff over HTTP without using SOAP, they think they're doing REST. They don't know *why* they should do hypermedia. Another reason is that no one's really sure *how* to do it. Darrel has made a really good shot at solving this problem, at least for Microsoft's WebAPI world, with his [Link](https://github.com/tavis-software/Link) library. Later I talked to Darrel about taking things further and lifting the knowledge about links between resources out of controllers to avoid duplication and thin out controllers and this is something he's also keen to explore.

### Semantics with [Jon Skeet](https://twitter.com/jonskeet)

This is the first time I'd seen Jon Skeet talk and he lived up to his reputation. Jon is an intelligent, articulate and knowledgeable speaker and a joy to watch. I share Jon's opinion on the phrase "that doesn't matter, it's just semantics". People seem to use this is a sweeping "that's not important" argument killer but it's never something I've really understood. Jon makes the point that semantics is meaning, and meaning is everything, so when people say this they are saying "that doesn't matter, it's just everything'.

### Noda Time with [Jon Skeet](https://twitter.com/jonskeet)

Because he only had one day to spare, Jon's 4 talks were compressed into a single day so I found myself following him around for the rest of the day. As the owner of several OSS projects and contributor to many more, I was interested to find out what Jon had learned whilst building [Noda Time](http://nodatime.org/). A couple of things in particular stood out. Jon has a contributor named Malcolm, who does a lot of the non-coding work around the project and his input is invaluable. I think this highlights the importance of never undervaluing contributors who don't write code. The other was his really interesting approach to CI. Whilst he has a public CI server, he also has a tiny little box running at home on top of a cupboard, completely dedicated to regular benchmark runs to prove that things will run consistently well on low spec hardware.

The challenges Jon outlined in the date and time domain are mind bending. Later, during the NDC welcome dinner, I had a hugely enjoyable conversation with Jon about more of the intricacies. If you ever get the chance to chat to Jon, do so. His passion and enthusiasm is thoroughly entertaining.    

### Dynamic vs Static Cage Match with [Jon Skeet](https://twitter.com/jonskeet) and [Gary Bernhardt](https://twitter.com/garybernhardt)

What a great way to finish the day. This was fun from start to finish. Arguments from both sides were well balanced and informative and both Jon and Gary flexed their coding muscles impressively. An on the fly C# implementation of Ruby's `result.Should = 2` from Jon really stood out.

I was also glad to help out on the static side when Jon managed to crash scriptcs whilst trying to list the methods on a type in an attempt to emulate Ruby's `methods` method. I spotted that the problem was in the JSV serialization going circular on methods and types when trying to render the REPL output and pointed this out to Jon so he could workaround it by picking off just the names of the methods using a LINQ `Select()`. This smells like a bug in ServiceStack.Text.  



**Tomorrow:** [@scottgu](https://twitter.com/scottgu), [FakeItEasy](http://fakeiteasy.github.io/) on stage and more...

### Names to faces checklist
[@jchannon](https://twitter.com/jchannon) [@Cranialstrain](https://twitter.com/Cranialstrain) [@gblock](https://twitter.com/gblock) [@jonskeet](https://twitter.com/jonskeet) [@dhelper](https://twitter.com/dhelper) [@stack72](https://twitter.com/stack72) [@paulcbetts](https://twitter.com/paulcbetts) [@davidfowl](https://twitter.com/davidfowl) [@DamianEdwards](https://twitter.com/DamianEdwards) [Mads Torgensen](https://www.google.co.uk/search?q=mads+torgensen)