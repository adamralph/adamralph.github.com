---
layout: post
title: Windows 10 version 1803 broke my git SSH
location: Copenhagen
tags:
---
I'm presenting a workshop tomorrow here at [MicroCPH](https://microcph.dk/). Windows has a way of knowing the best times to apply major updates. Sure enough, Windows 10 version 1803 (April 2018 Update) appeared on my laptop yesterday. All seemed fine until I tried to do some work with git.

I use SSH rather than HTTPS to talk to git remotes. The SSH agent was up and running, with my SSH key added to it. Business as usual. The problems started when I ran `git remote update`. I was prompted for the password for my SSH key. Then I tried `git push`. Again I was prompted for my password. Git and the SSH agent were no longer friends.

<!--excerpt-->

It turns out that the [OpenSSH client is enabled by default in the 1803 update](https://blogs.msdn.microsoft.com/commandline/2018/03/07/windows10v1803/) (it was added as an optional beta feature in 1709). When posh-git starts the SSH agent, it uses the binaries in `%windir%/system32/OpenSSH/` (added in 1803). Git wants to use the local SSH binaries in `%programfiles%/Git/usr/bin/` (bundled with git). It seems that these two sets of SSH binaries don't play together.

The solution I chose was to configure git to use the Windows-bundled SSH binaries. I added the following entry to my global `.gitconfig`:

```
[core]
  sshCommand = \"C:/Windows/System32/OpenSSH/ssh.exe\"
```

If you have the same problem, I hope this helps!
