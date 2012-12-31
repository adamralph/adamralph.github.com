---
layout: post
title: Introducing Nugit
---

#Introducing Nugit

I'd like to introduce you to a new site called <a href="http://nugit.org">Nugit</a>. I've been working on this for several weeks and have gone through many different rewrites of the core as well as the basic idea of what the site is. I'm opening the site up to get public opinion and to find any bugs that I am not able to find myself and to see what direction I could take this site.

##What is it?

The basic premise is to make creating <a href="http://nuget.org">Nuget</a> packages simple and easy by integrating with your source control provider. Github repos are monitored through webhooks and any commits are automatically downloaded by the site and packaged. This site started off with the idea that codesnippets could easily be integrated to your projects through the use of Nuget and Github gists. From there and through the counsel of Jon Galloway it has grown to include entire repos.

##Package configuration

Most settings for the package are controlled through the repository. Properties like <strong>Description</strong> and <strong>License</strong> and others are taken care of straight from the repo files themselves. Packages can configured through a special <strong>nugit.config</strong> file that can be included in your Github repo. This places control of the settings to your source control provider without having to go to the site every time. You can set your icon, what files to include, and other settings in the future through this config file.

##Support

Currently only <a href="https://github.com">Github</a> is supported but we have plans to support others. We have a <a href="http://groups.google.com/group/nugit">Google Group</a> set up for discussion and <a href="http://nugit.uservoice.com">Uservoice</a> for bug tracking and feature requests. 

I welcome all <a href="http://groups.google.com/group/nugit">feedback</a>, both positive <strong>and</strong> negative.

###- Ben Dornis