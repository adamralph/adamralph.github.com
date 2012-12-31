---
layout: post
title: Introducing csharptube.com
---

While introducing a friend of mine to c# I realized that it's hard to find good (free) videos online. I thought that there could be a single place to go and harvest all these videos from across the web. Categorize them, rank them, and display them with a common interface. The site should have a nice clean and simple site for finding and viewing c# and related videos. 

To that end I've adopted a lot from <a href="http://stackoverflow.com">Stackoverflow.com</a>. The simplicity of loging in, the voting of videos, and tagging. In addition, I've borrowed a concept from Rob Conery's <a href="http://tekpub.com">Tekpub</a> that allows users to keep track of their position while watching. You can then come back later and continue from where you left off.

##How do videos get added?

Videos can be added by anyone. All you need is the url from <a href="http://www.youtube.com">Youtube</a> or <a href="http://channel9.msdn.com">Channel 9</a>. More providers will be added as time goes on.

Before they are made fully public they will go through a vetting system. When a threshold is reached the video will be "published". This will hopefully keep the lower quality videos from appearing on the site. (And keep completely unrelated videos from showing up at all)

##Interesting Nuget packages used by c# tube

Here are a few of the not-so-common packages used.

<ol>
<li><a href="http://nuget.org/List/Packages/ScrapySharp">ScrapySharp</a></li>
<li><a href="http://nuget.org/List/Packages/HtmlAgilityPack">HtmlAgilityPack</a></li>
<li><a href="http://nuget.org/List/Packages/Errlusion">Errlusion</a></li>
</ol>

ScrapySharp provides css selector like access to html. This makes screen scraping fairly easy. Scraping was necessary to integrate Channel9 videos into the site. (HtmlAgilityPack was required for Scrapy)

Errlusion is a convention based error handler for Mvc. Any unhandled exceptions, HttpStatusCodes can be routed through Errlusion.

##Relationship to sites like Tekpub

I have great respect for Rob Conery and his dedication to the quality of the videos of Tekpub. I have purchased many videos from Tekpub and will continue to do so in the future. This site is not meant to be competition for them but a way for the starving developer to easily find high quality videos that are available from everywhere on the internet.

##Check it out

Please check out the site at <a href="http://csharptube.com">http://csharptube.com</a> and let me know what you think. I'm always on David Fowler's <a href="http://jabbr.net">Jabbr</a> and you can join me in the <a href="http://jabbr.net/#/rooms/csharptube">csharptube</a> room.

<strong>-Ben Dornis</strong>