---
layout: post
title: Continuously Losing Internet Connectivity in Windows 8.1
description: This has been driving me nuts recently. On my two Windows 8.1 machines, I'll be happily using the internet. You know browsing, pushing to GitHub, Tweeting, that kind of thing. Then all of a sudden everything would blow up. Browser tabs would hang trying to load pages. JabbR would go red. GitHub fetches would fail. On my one remaining Windows 7 machine all was good.
location: Flims
tags:
- sysadmin
---

### TL;DR

1. Execute `netsh winsock reset`
1. Restart machine

### The excruciating story behind this

This has been driving me nuts recently. On my two Windows 8.1 machines, I'll be happily using the internet. You know browsing, pushing to GitHub, Tweeting, that kind of thing. Then all of a sudden everything would blow up. Browser tabs would hang trying to load pages. JabbR would go red. GitHub fetches would fail. On my one remaining Windows 7 machine all was good.<!--excerpt-->

I found I could fix the problem by disconnecting  and reconnecting my WiFi connection. After a while it would happen again. Worst of all, it's been happening at just that frequency which is not quite enough for me to stop what I'm doing and sort out the problem once and for all, but just enough to very slowly accumulate a snowball of anger and hate which has been welling inside me for the past couple of weeks.

Today it was finally too much so after a disconnect/reconnect I decided to sort out the problem once and for all. First of all, I found a thread telling me I should I should switch off 'Allow the computer to turn off this device to save power' for the network adapter. I tried that and everything looked fine for around 15 minutes until I lost my connectivity yet again. A deep breath and back to the drawing board.

I then took my woes to [#general-chat](https://jabbr.net/#/rooms/general-chat) over on JabbR where both [@bryan_wood](https://twitter.com/bryan_wood) and [@davepermen](https://twitter.com/davepermen) suggested it may be a DNS problem. This sounded likely since I do remember the browser status spending a while on 'Resolving host'. So I pinged google.com, grabbed the IP and waited patiently for my internet stack to fall over again which of course it politely obliged. I found I could still ping the IP which again hinted at a DNS problem. I then ran `ipconfig /flushdns` and hey presto! I could browse sites again.

Having narrowed it down to a local problem (I had suspected my WiFi router which is way past its prime) I continued my search for problems specifically regarding Windows 8.1 and DNS. Lo and behold the internet is full of people complaining about this. There was even a question raised on [answers.microsoft.com](http://answers.microsoft.com/en-us/windows/forum/windows8_1-performance/dns-issues-since-upgrading-to-81/8e5b5a68-e8e6-462a-b53e-cde8915e82df) in October last year with still no resolution from Microsoft.

More Googling, and I found this little gem which told me all I had to do was run `netsh winsock reset` and restart my machine. **Any by god it seems to be working**. Around 2 hours continuous, flawless connectivity which is an order of magnitude longer than I've experienced in the last fortnight. I'm not out of the woods yet, but I'm optimistic.

### What does the command do?

A good question and I had absolutely no idea until I started digging around (I'm a netsh noob). `netsh winsock reset ?` reveals that the command

```
Resets Winsock Catalog to a clean state.
All Winsock Layered Service Providers which were previously
installed must be reinstalled.
This command does not affect Winsock Name Space Provider
entries.
```

According to [Wikipedia](http://en.wikipedia.org/wiki/Winsock#Microsoft_implementations)

> Winsock 2 is extensible by a mechanism known as a Layered Service Provider (LSP). Winsock LSPs are available for a wide range of useful purposes, including Internet parental controls, web content filtering, QoS etc. The layering order of all providers is kept in the Winsock Catalog. In previous versions of Windows, removing a buggy LSP could result in corruption of the Winsock catalog in the registry, potentially resulting in a loss of all network connectivity. Winsock in Windows XP Service Pack 2, Windows Server 2003 Service Pack 1 and all later Windows operating systems has the ability to self-heal after a user uninstalls such an LSP.

So it seems there is probably a buggy LSP sitting in there which is probably added by Windows 8.1 or at least one of the apps it comes bundled with. I guess it could also be a third party app but given so many people have had the problem and that it only manifests in Windows 8.1 and not Windows 8, suggests it's something fairly close to the metal in the Windows 8.1 distribution. Let's hope MS fix this soon so this blog post becomes redundant.
