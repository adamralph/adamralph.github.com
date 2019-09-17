---
layout: post
title: PowerPoint and Word failing to open
location: Flims
tags:
- sysadmin
---
Yesterday, PowerPoint and Word suddenly started to refuse to open. I'd get the splash screens saying "Starting..." but then they would disappear and... nothing. (I'm using Windows 10 version 1803 and Office Professional Plus 2016.)

First I searched to see if anyone else was suffering a similar problem. The recent [Windows 10 version 1803 update](/2018/05/15/windows-10-version-1803-broke-my-git-ssh/) was one of my prime suspects. I couldn't find anything so I decided to take matters into my own hands.

<!--excerpt-->

I went to "Settings -> Apps -> Apps & Features -> Microsoft Office Professional Plus 2016 -> Modify". That gave me two options: "Quick repair" and "Online repair". I tried both, and they made no difference. I then did a full un-install and re-install of Office. Again, no joy. The threat of a full machine rebuild started to loom over me. I went to bed and attempted to get some sleep.

After lying awake for several hours I sneaked into my office at a ridiculous hour. I managed to find [an interesting Microsoft support article](https://support.microsoft.com/en-gb/help/921541/how-to-troubleshoot-problems-that-occur-when-you-start-or-use-word). It describes the removal of some registry keys as a possible solution for start up problems with Word. I guess my search-fu is better at five in the morning.

Sure enough, when I removed the `HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word` and `HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\PowerPoint` keys, both the apps opened without problem!

Of course, I couldn't stop there. Those registry keys have a lot of nested content, and I wanted to find out exactly what was causing the problem.

Before deleting the keys, I exported them to disk. To narrow down the problem, I re-imported them, deleted half the sub-keys, and tried to open the apps again. A typical "bisect" style problem investigation. Many tedious rounds of this commenced. I identified problematic sub-keys, repeated the bisection inside them, and so forth. Eventually, I managed to identify exactly which values were problematic:

- Word
  - Key: `HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Options`
    - Value: `AppWindowPos`
- PowerPoint
  - Key: `HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\PowerPoint\Options`
    - Value: `Left`
  - Key: `HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\PowerPoint\Resiliency\StartupItems`
    - Value: `ru4`

After removing only those values, the apps were able to start.

The weird thing is that both the `AppWindowPos` and `Left` values relate to the application window position. Even weirder is that the `ru4` and `Left` values for PowerPoint are related. Removing only one of those keys wasn't enough. I had to remove both. Weirder still is that the entire `HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\PowerPoint\Resiliency` key (the parent of the key from which I removed a value) disappeared after I closed PowerPoint.

I have no idea why those keys were problematic. I'm just glad I solved the problem. If I hadn't found that article, I may be rebuilding my machine right now instead of writing this blog post. I hope this might help someone else if they ever have a similar problem.
