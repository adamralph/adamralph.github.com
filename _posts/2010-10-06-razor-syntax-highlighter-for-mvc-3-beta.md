---
layout: post
title: Razor syntax highlighter for mvc 3 beta
---

##Razor Syntax Highlighter

Thanks goes out to the wonderful team at Microsoft and their MVC engine.

First, you'll need to install MVC 3 Beta either from <a href='http://www.microsoft.com/web/gallery/install.aspx?appid=MVC3'>Web Platform Installer</a> or install it <a href='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=0abac7a3-b302-4644-bd43-febf300b2c51&amp;displaylang=en'>manually</a>. Once you have this you'll want to update your installation or download it from the <a href='http://visualstudiogallery.msdn.microsoft.com/en-us/8dc77b9c-7c83-4392-9c46-fd15f3927a2e'>Visual Studio Gallery</a>.

##New Features

The razor syntax has changed. Comments no longer work the same way and must be contained within a <strong>@{ }</strong> tag. However you cannot use <strong>@{//comment}</strong> as the } will be parsed as a comment. This is a real shame but a requirement for new features.

As a result of this new parser I've been able to tap into the awesomeness that is syntax errors. We now support basic syntax errors for the razor engine. This, however, does not include c# errors.

<a href="http://aws.buildstarted.com/razorsyntaxerror.png"><img src="http://aws.buildstarted.com/razorsyntaxerror.png" alt="" title="Razor Syntax Error Example" width="543" height="158" class="size-full wp-image-428" /></a>

I had attempted to get some basic intellisense for this version but the breaking changes of Beta 3 forced me to put that on hold. (sorry...)

Please post any errors here, in the comments. I've been testing it most of the day and I think I've got most of them gone.

###- Ben