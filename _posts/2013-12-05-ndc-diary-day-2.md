---

layout: post
title: NDC Diary - Day 2
location: London
tags:
- NDC
---

I woke up this morning with a slightly larger hangover than yesterday and a nasty lack of sleep but it was offset with the fond memory of pwning [@DamianEdwards](https://twitter.com/DamianEdwards) and [@davidfowl](https://twitter.com/davidfowl) on the pool table.

### Cloud Apps on Azure with [Scott Guthrie](https://twitter.com/scottgu)

Azure is an interesting one for me. Whilst I can see that cool stuff is being done on Azure, I'm still reluctant to treat Azure as anything other than 'yet another service provider'. The reason for this is the maintenance of portability and, ultimately, choice. I use an Azure VM as a build server. I might use one to host a blog. I might use one to host some windows services. I might use Azure websites to host an IIS website. All of these things I could potentially pick up and move elsewhere should I become dissatisfied with Azure for some reason. If I wrote my code against Azure specific SDK's then I would lose this portability. I'd be locking myself into Azure. Somehow this just doesn't sit right with me and I can't bring myself to do it. This is a shame, because there's so much cool stuff in Azure and I'd like to be able to use it. But the platform and vendor lock in just scares me off. The awesome content which the red-shirted maestro presented today makes the two opposing considerations pull at me even harder.

<!--excerpt-->

### Battle of the Mocking Frameworks with [Dror Helper](https://twitter.com/dhelper)

As an owner of [FakeItEasy](http://fakeiteasy.github.io/), how could I not attend this talk? Dror prepared a thorough examination of most of the popular mocking frameworks including comparisons on aspects which I never would have thought of myself, such as deployment. I didn't realise deployment has such an impact with the commercial offerings. The API and test fragility comparisons were mostly familiar to me, with the exception of a brief shock at seeing the MS Fakes syntax. The conclusion of the battle was, as I expected, 'it depends' but I'm glad to report that FakeItEasy did very well indeed and scored highly in all aspects. There was one clear loser however, and I'm afraid to say it was MS Fakes.

### Functional programming with [Uncle Bob](https://twitter.com/unclebobmartin)

The chance to see Uncle Bob in the flesh was too much to resist. I'd previously watched Bob's 'Expectations from your new CTO' talk over a live web cast and found it hugely entertaining. Uncle Bob has a habit of spending the first few minutes speaking about something not directly related to the topic. In the previous talk it was the speed of light, in this talk it was quantum interference patterns. I've no idea why he does this but it's a lot fun. As a seasoned master, Uncle Bob typically uses computing history to lay the foundations of his message. Today he gave us a fascinating tour of the astounding level of hardware innovation over the last 60 years and starkly contrasted that with the lack of innovation in programming languages which, ultimately, haven't changed that much. Did he get his message across? Yes. Functional programming was the first of three language revolutions, the others being OO and structural. Bob convinced me how important functional programming languages are becoming right now and will be in the future and I left the talk wanting to learn a functional language!

### Clojure Coding Dojo with [Rob Ashton](https://twitter.com/RobAshton)

So, I left Uncle Bob's talk wanting to learn a functional language, and as I walked into the main hall I found Rob Ashton sitting at a table with his laptop, wanting to teach me a functional language, Clojure. So a few of us gathered round Rob's laptop for an spontaneous coding dojo and the VIM maestro went to work. The challenge: produce an infinite series of simulated stock price ticks, with up/down market price movement. This was my first coding dojo and the unexpected part was when we had to rotate the typist, one function each. What this means is that you don't just learn the language, but you also learn the tools. Rob's tool is VIM. I was like a fish out of water but I struggled through my turn on the keyboard and was happy to have a working function when I was done. As time ran out and the next talk was due, Rob took over and finished things off and our target was achieved!

### F# and DDD with [Scott Wlaschin](https://twitter.com/ScottWlaschin)

Continuing my new found determinism to learn a functional language I headed over to learn how to use F# in DDD. After a few DDD basics which I was largely familiar with, my illusions about the F# type system were completely blown away. I had naively assumed that F# types were largely equivalent to C# classes but that couldn't be further from the truth. My criticism of the talk is that the examples shown were somewhat anaemic in terms of DDD. They were more about data structure than behaviour. However, I'm now intrigued as to how I might implement a domain in one of my real projects in F#, in combination with things like CQRS and event sourcing. To be continued...
 
**Tomorrow:** Recording a show about scriptcs for DotNetRocks with [@gblock](https://twitter.com/gblock) and [@jrusbatch](https://twitter.com/jrusbatch)

## Names to faces checklist

[@scottgu](https://twitter.com/scottgu) [@unclebobmartin](https://twitter.com/unclebobmartin) [@BrockLAllen](https://twitter.com/BrockLAllen) [@citizenmatt](https://twitter.com/citizenmatt) [@RemoGloor](https://twitter.com/RemoGloor)