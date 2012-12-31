---
layout: post
title: Replacing default git bash console with Console2
---

I really like git. I use it for every project I create. Sometimes even for random stuff unrelated to programming at all when I want to have versioning. One thing that always bugged me was the shell that msysgit comes with. I decided to replace it with Console2. 

If you don't know why Console2 is awesome I suggest you read <a href='http://www.hanselman.com/'>Scott Hanselman's</a> blog post on it <a href='http://www.hanselman.com/blog/Console2ABetterWindowsCommandPrompt.aspx'>here</a>.

####Step 1: Download Console2
You can download the latest version of <a href='http://sourceforge.net/projects/console/'>Console2</a> from <a href='http://sourceforget.net'>SourceForge</a>. It's just a zip file so you can put it anywhere. I put mine in <strong>C:\Program Files (x86)\Console2</strong>.

####Step 2: Configure Console2 to use bash instead of the default DOS shell.
There are two ways you can go about this. If you are used to the linux shell you can force Console2 use bash always or we can set it up to only use bash when we use git. To replace the DOS shell entirely open up the settings for console2 and add <strong>"C:\Program Files (x86)\Git\bin\bash.exe" --login -i</strong> 
<img src='http://aws.buildstarted.com/git-shell.png' />
Or you can create a git specific config file and put it in root of the Console2 directory. To create it just copy the existing <strong>console.xml</strong> and change the <strong>shell</strong> attribute of <strong>console</strong> to your bash location (replace " with &&quot;).

####Step 3: Modify the registry to make the context menus point to Console2 instead of the git bash directly.

    Windows Registry Editor Version 5.00

    [HKEY_CLASSES_ROOT\Directory\shell\git_shell\command]
    @="\"C:\\Program Files (x86)\\Console2\\Console.exe\" -d \"%1\" -c \"git-config.xml\""

Change the path to one appropriate to your installation location and if you're not using a custom config remove the -c parameter.

####Step 4: Enjoy console2

<img src='http://aws.buildstarted.com/git-example.png' />

<strong>- Ben Dornis</strong>