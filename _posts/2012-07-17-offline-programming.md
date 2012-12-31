---
layout: post
title: Offline programming
---

This is the first in an n-series of posts about programming while offline. I'll be posting about issues and solutions to these issues that I come across.

####Why?
I recently bought a house but it's not quite ready to move into yet. My wife and I also expecting our first child and since we've already gone through the process of finding a doctor and hospital and what not to have the baby at we're just not ready to move. However, we go there just about every weekend. Little things that need to be done such as the lawn. Receiving furniture. Minor remodeling.

With the length of time I spend there I don't feel justified in paying for internet access just yet.

This has led to a small conundrum. I am unable to develop the same there as I do at my apt.

Almost every project I have relies on access to Nuget. CDN hosted js files such as jQuery. Most of my public projects are hosted on Github. 

####Simple solutions
Nuget is easy enough to replace by downloading all of the packages that I use onto a removable drive. Access is generally slower than Nuget.org because it has no index to search.

CDN hosted files could be hosted locally as well but with changes to how I'm pointing to them.

Github hosted projects are probably the easiest because git makes this nice and easy. I can push all of my commits at a later time, however it does mean I need to pull my repos to a removable drive.

####Other issues
A lot of my projects also revolve around Amazon's AWS. It's what we use at work. I love trying out new things related to their offerings but there's no <em>emulation</em> mode available to do offline testing.

I also love to read about technologies that I don't know about or would like to learn more about. I've been reading about Redis and Memcached and other similar libraries/services. Harder to read about them offline.

I also tend to chat a lot with other devs about issues I might be having with some code. I don't have internet on my phone and find phone keyboards to be too awkward anyway to chat on anyway so that's a non-issue. This will make collaboration a bit harder.

####However
Sometimes you need a break from all the distractions. The latest Youtube video viraling out of control on the internet or funny cat pictures won't consume some of my precious time. No email from work. 

Twitter won't interrupt me with the latest technology or blog post written by one of my peers. Every weekend I miss out on all the interesting stuff that may have happened. I've made it a rule to just ignore it. I don't go back and browse the history of what I might have missed. (Unless it was directed at me specifically)

####Final
So far offline development hasn't been a picnic. Lots of downsides with a few upsides. I'll be going over these in more detail when/if I find better ways around them.

<strong>-Ben Dornis</strong>