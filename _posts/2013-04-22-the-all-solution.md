---
layout: post
title: The All Solution
location: Zurich
tags:
- integration
- ddd
- source control
---
Once upon a time my team had all their code all nice and neat and all in one place. It was all conveniently located in one SVN repo in a single solution. This solution contained many apps which were worked on by some people who worked closely together and others only loosely connected in their day to day activities (a shared line manager but little more). I present to you the 'All' solution.

<!--excerpt-->

![All.sln](https://raw.github.com/adamralph/adamralph.github.com/master/img/all-solution.png)

What could be better? Less overhead since you don't have to 'maintain' lots of SVN repos. Easier to locate code since it's all in one place. Lots of nice reuse between applications. We know how to organise our code!

Sadly, nothing could be further from the truth.

The solution shown is for a fictional team named 'HGC' who develop fictional apps 'Andromeda', 'Gemini', 'Jupiter' and 'Saturn'. The rest of the projects are so called 'common' libraries which are to be reused between applications. This is very similar to how my team had their code organised when I joined the team. In fact, our All solution was *way* bigger than this. Some of the problems with this approach are:

- **Technological stagnation.** The apps get so locked together and locked into the same frameworks and approaches that it becomes nearly impossible to try new things and innovate.

- **Lack of defined and recognisable bounded contexts.** Models bleed into and corrupt each other with no discernible integration patterns.

- **Spaghetti like references.** Saturn shouldn't *really* reference Andromeda, but it does! Need something from Jupiter? Reference it!

- **Little refactoring.** Developers are worried about changing *anything* because it's so difficult to tell what will break. (Good test coverage alleviates this but this was also severely lacking in our case!)

- **Huge build times.** Our All solution took well over an hour to build!

- **Lack of modularisation within apps (look at Hgc.Jupiter).** Developers are afraid to break out apps into defined layers/modules because then there would be 'too many projects'.

- **Very difficult for each application to evolve independently.** We can't change the Hgc.Mars0 'reusable' library to do something differently for Hgc.Saturn because it would break Hgc.Gemini!

- **Package updates can be nearly impossible.** You need a new version of package X for Saturn but it might break Jupiter and then you have to run all that manual regression testing again. Argh! You can go with different versions of packages for different apps but then it takes a brave soul to venture into the packages folder and attempt to make head or tail of it!

As we learnt more about DDD and also gained more exposure to OSS projects, we slowly realised that this approach made no sense at all. It was more driven by the organisation of personnel rather than the meaning of the code and the applications. Recognition of bounded contexts and integration patterns where necessary showed us that we were mixing separate concerns all into the same pot for no good reason. Imagine mixing unrelated OSS projects together in a single GitHub repo!

These days, each bounded context lives in it's own repo containing a single solution. Any app which needs to talk to another uses a well defined integration pattern, e.g. Web API or message bus. Build times are down to minutes, if not seconds. Each app is nicely modularised, e.g. Gui, Console, Website, Model, Persistence, Infrastructure. We're continuously innovating by trying new ways of doing things within the bounded context of a single application. Each application can evolve independently at it's own pace. Of course there are still bits of mess here and there but it's a different world now we've escaped the clutches of the All solution and the All repo.

Splitting our code into single bounded context repos and solutions was one of the best things we ever did for our productivity. If the 'All' solution and/or 'All' repo look familiar to you, consider breaking things up. I guarantee you won't regret it.