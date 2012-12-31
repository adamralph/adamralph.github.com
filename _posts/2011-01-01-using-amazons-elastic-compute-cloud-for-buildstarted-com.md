---
layout: post
title: Using amazons elastic compute cloud for buildstarted com
---


<style type='text/css'>
    table#instances {
        border-collapse:collapse;
        width:100%;
        border:solid 1px gray;
    }
    table#instances tr td {
        border:solid 1px gray;
        padding:3px;
    }
    table#instances .micro td {
        background-color: #ccc;
        font-weight:bold;
    }
</style>


After a few outages of my previous host I've decided to move my server to Amazon's <a href='http://aws.amazon.com/ec2/'>EC2</a> services. I have to tell you it was <strong>not</strong> an easy transition. I was more than confused with the array of options on Amazon's services.

I'm going to go over exactly the choices I've made and what I did to get it working.

##Type of machine

This site isn't the most popular on the internet so I don't need anything really powerful. Here are the systems available for websites:

<table id='instances' style='width:100%;' cellpadding='3' cellspacing='0'>
<thead><th>Type</th><th>Ram</th><th>Processors</th><th>Storage</th><th>Platform</th></tr></thead>
<tbody>
<tr class='micro'><td>Micro</td><td>613MB</td><td>Up to 2 ECUs (for short periodic bursts)</td><td>EBS only</td><td>32 or 64 bit</td></tr>
<tr><td>Small</td><td>1.7 GB</td><td>1 ECU (1 Virtual core with 1 EC2 Compute Unit)</td><td>160 GB local storage</td><td>32 or 64 bit</td></tr>
<tr><td>Large</td><td>7.5 GB</td><td>4 ECUs (2 virtual cores with 2 EC2 Compute Units each)</td><td>850 GB local storage</td><td>64 bit</td></tr>
<tr><td>Extra Large</td><td>15 GB</td><td>8 ECUs (4 virtual cores with 2 EC2 Compute Units each)</td><td>1690 GB local storage</td><td>64 bit</td></tr>
</tbody>
</table>

I've decided to go with the <strong>Micro</strong> server. It's cheap (currently free for one year) and it fits my needs. I haven't had another asp.net referral for a while though (<em>hint</em>, <em>hint</em>) so I might need to upgrade to a small server when that time comes. Incidentally that's one of the great things about Amazon's service: I can change the server type at a whim <strong>without</strong> reconfiguring the system.

##AMI's

<div style='text-align:center;'><a href='http://aws.buildstarted.com/instancelist.png'><img src='http://aws.buildstarted.com/instancelist.png' style='width:100%;' /></a></div>


AMI's or Amazon Instance Machines are the bases for any system you wish to start up on EC2. There are a wide range of over 6000 different systems available on the Community AMI list from Windows to Linux and even OpenSolaris to custom server types like a default wordpress and joomla setups. I chose a blank Ubuntu setup as that is what I'm familiar with and I know what I'm getting since I'll be forced to install everything myself.

###Setting up your new machine

The first step in setting up your new machine is to choose what type of instance you want.

<div style='text-align:center;'><a href='http://aws.buildstarted.com/instancetype.png'><img src='http://aws.buildstarted.com/instancetype.png' style='width:100%;' /></a></div>

You have a selection, based on your chosen ami, of what type of machine you want. This is really powerful as a single AMI can be any type of system you want. So if your site is small - like this one - but it gets really popular you can either add new instances of the same type for load balancing <em>or</em> you can just change the type of machine your instance runs on. I can't figure out how the hell they do this but it's damn awesome.

####Kernel/Ram

<div style='text-align:center;'><a href='http://aws.buildstarted.com/instancedetails.png'><img src='http://aws.buildstarted.com/instancedetails.png' style='width:100%;' /></a></div>

I have no clue exactly what this is. I just use the default Kernel and RAM Disks. Here you can enable CloudWatch which allows you to see detailed information on disk/ram/network usage while your machine is running.

####Machine Tags

<div style='text-align:center;'><a href='http://aws.buildstarted.com/instancekeys.png'><img src='http://aws.buildstarted.com/instancekeys.png' style='width:100%;' /></a></div>

Here you can add some tags. The default one of Name always works well. Tags are really only useful if you have a lot of different instances in your list and you want to quickly find instances based on a particular attribute.

####Key pairs

<div style='text-align:center;'><a href='http://aws.buildstarted.com/instancekeypair.png'><img src='http://aws.buildstarted.com/instancekeypair.png' style='width:100%;' /></a></div>

Here you can create a key pair for remote access to your system. This doesn't require you to remember a username or password - which, as we've seen with the recent <a href='http://www.codinghorror.com/blog/2010/12/the-dirty-truth-about-web-passwords.html'>Gawker incident</a>, is never a good idea. Store your keypairs in a safe place. When you ssh with a client such as PuTTY you'll set your auth to your keypair you've created here.

####Firewall

<div style='text-align:center;'><a href='http://aws.buildstarted.com/instancefirewall.png'><img src='http://aws.buildstarted.com/instancefirewall.png' style='width:100%;' /></a></div>

Setting up your instance firewall allows you to open ports to your instance and make it available to the internet or a select ip range. I've opened up HTTP and SSH here as all I would need is a cheap web server and nothing more. Though I've selected <strong>All Internet</strong> for both options I would recommend you only use a port range for something like SSH. But for testing, who cares? :)

####Launch

<div style='text-align:center;'><a href='http://aws.buildstarted.com/instancereview.png'><img src='http://aws.buildstarted.com/instancereview.png' style='width:100%;' /></a></div>

This page is just a review of what you've selected on the previous pages with the option to go back and make changes if you screwed up somehow. If everything is good you just need to click <strong>Launch</strong>.

###EBS Storage

All <strong>Micro</strong> Instances must be stored using EBS. I didn't know what this meant at first but I understand now. I did a lot of extra stuff after I setup my server such as backing up my wordpress database once a day and restoring the database on boot. I found that this isn't necessary as EBS instances are more permanent and store stuff on your EBS storage. This does introduce possible other costs but this website exists mostly in cache so it's not really an issue. For instance-only storage for some AMI's any changes to the filesystem do <em>not</em> persist when the machine is shut down. This is a very important distinction. Since you can use Instances for stuff other than hosting, like data processing, it may or may-not be necessary.

##Costs





<table id='instances' style='width:100%;' cellpadding='3' cellspacing='0'>
<tr><th>Costs</th><th>Linux Hour</th><th>Windows Hour</th><th>Linux Year</th><th>Windows Year</th></tr>
<tr><td>Micro</td><td>$.02</td><td>$.03</td><td>$175.20</td><td>$262.80</td></tr>
<tr><td>Small</td><td>$.085</td><td>$.12</td><td>$744.60</td><td>$1051.20</td></tr>
<tr><td>Large</td><td>$.34</td><td>$.48</td><td>$2978.40</td><td>$4204.80</td></tr>
<tr><td>Extra Large</td><td>$.68</td><td>$.96</td><td>$5956.80</td><td>$5956.80</td></tr>
</table>



The above costs are for instances that haven't been reserved. Windows costs are all slightly more per hour than Linux.





<table id='instances' style='width:100%;' cellpadding='3' cellspacing='0'>
<tr><th>Reserved Costs</th><th>1 Year</th><th>3 Years</th><th>Linux</th><th>Windows</th><th>Linux Year</th><th>Windows Year</th></tr>
<tr><td>Micro</td><td>$54.00</td><td>$82.00</td><td>$.007</td><td>$.013</td><td>$61.32</td><td>$113.88</td></tr>
<tr><td>Small</td><td>$227.50</td><td>$350.00</td><td>$.03</td><td>$.05</td><td>$262.80</td><td>$438.00</td></tr>
<tr><td>Large</td><td>$910.00</td><td>$1400.00</td><td>$.12</td><td>$.20</td><td>$1051.20</td><td>$1752.00</td></tr>
<tr><td>Extra Large</td><td>$1820.00</td><td>$1820.00</td><td>$.24</td><td>$.40</td><td>$2102.40</td><td>$3504.00</td></tr>
</table>



The above costs are for reserved instances. You can purchase an instance ahead of time, such as a small, for a one time fee. In return you get a discount price per hour for the length of your purchase. Windows prices may fluctuate over the course of your contract, however. I was thinking about reserving a Micro instance as the savings is quite significant over the course of 3 years at a savings of over 50%. However, thinking about it more and more...if this site gets more popular over time I may need to change from Micro to Small - in which case my reserved instance is no longer the savings machine it was. Just something to think about. I doubt I'll need anything more than my Micro but you never know...it's up to the community to **make** me upgrade. However, doing the math, even if I needed to upgrade the server from Micro to Small in 6 months I would still save money by reserving an instance. 

I won't do that though - the Micro is currently free to new subscribers to Amazon's EC2 service

##Final

As I learn more about this process I will post more. This whole setup has brought up some questions that I'm sure I'll find the answers for over time (I'll probably head over to <a href='http://www.serverfault.com/'>serverfault.com</a> and ask them!) I'm currently finalizing another site that I intend to host on Amazon's EC2 service that will be much more popular. (I hope) So I should have a chance to test stuff like upgrading the server to a more powerful machine and what not to see how that works.

###Ben