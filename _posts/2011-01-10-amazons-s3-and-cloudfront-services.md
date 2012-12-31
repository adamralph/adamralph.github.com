---
layout: post
title: Amazons s3 and cloudfront services
---

This is my company's busy season and the sudden outage of one of our T1 lines resulted in us scrambling for a solution to give our clients access to their downloads at a reasonable speed. 15Kbps is <em>not</em> acceptable! I happen to just start using Amazon's EC2 for personal reasons and was thus becoming familiar with the system. We needed to setup a remote host right away. Including our webserver. (Not just files) So, after a brief discussion, I offered to use my account for hosting so that we can get up and running right away. This was going to be my first Windows machine setup.

Anyway, after we set this up we realized that we only really need file hosting and not full hosting. So we looked up <strong><a href='http://aws.amazon.com/s3/'>S3</a></strong> on Amazon. We could then put the files up on S3 while having our webserver just point to the new locations on our locally hosted site.

##S3

S3 (which stands for Simple Storage Service) is a filehosting service offered by Amazon. It's not a webserver. It doesn't execute or parse scripts. It simply serves files. The pricing for the service seems to be on par with similar pricing for outbound data for EC2 so there really aren't going to be any surprises for this. Most people won't use more than 1TB unless you've got a lot of data that a lot of people want. You're looking at $0.14 per GB which is a tad expensive. But you're taking advantage of Amazon's huge infrastructure to deliver these files...so it's up to you what you do.

Pricing for their storage - and this is actual storage not bandwidth costs. This is an important distinction. Also, prices are <strong>Per Month</strong>.
<style type='text/css'>
    .rowhighlight {
        background-color: #ccc;
        font-weight:bold;
    }
    table#s3 {
        border-collapse:collapse;
        width:100%;
        border:solid 1px gray;
    }
    table#s3 tr td {
        border:solid 1px gray;
        padding:3px;
    }
</style>

<table id='s3'>
    <thead>
        <tr>
            <th>Storage Amount</th>
            <th>Standard pricing (Per Gigabyte)</th>
            <th>Reduced Redundancy Storage (Per Gigabyte)</th>
        </tr>
    </thead>
    <tbody>
        <tr class='rowhighlight'>
            <td>1TB</td>
            <td>$0.140</td>
            <td>$0.093</td>
        </tr>
        <tr>
            <td>49TB</td>
            <td>$0.125</td>
            <td>$0.083</td>
        </tr>
        <tr>
            <td>450TB</td>
            <td>$0.110</td>
            <td>$0.073</td>
        </tr>
        <tr>
            <td>500TB</td>
            <td>$0.095</td>
            <td>$0.063</td>
        </tr>
        <tr>
            <td>4000TB</td>
            <td>$.080</td>
            <td>$0.053</td>
        </tr>
        <tr>
            <td>5000TB +</td>
            <td>$0.055</td>
            <td>$0.037</td>
        </tr>
    </tbody>
</table>

Data Transfer Costs:

<table id='s3'>
    <thead>
        <tr>
            <th>Data Transfer Costs</th>
            <th>Standard pricing</th>
        </tr>
    </thead>
    <tbody>
        <tr class='highlight'>
            <td>IN</td>
            <td>$0.10</td>
        </tr>
        <tr>
            <td>1GB</td>
            <td>$0.00</td>
        </tr>
        <tr>
            <td>10TB</td>
            <td>$0.15</td>
        </tr>
        <tr>
            <td>40TB</td>
            <td>$0.11</td>
        </tr>
        <tr>
            <td>100TB</td>
            <td>$0.09</td>
        </tr>
        <tr>
            <td>150TB +</td>
            <td>$0.08</td>
        </tr>
    </tbody>
</table>

Request Costs:

<table id='s3'>
    <thead>
        <tr>
            <th>Requests</th>
            <th>Standard pricing</th>
            <th>Number of Requests</th>
        </tr>
    </thead>
    <tbody>
        <tr class='highlight'>
            <td>PUT, COPY, POST, LIST</td>
            <td>$0.01</td>
            <td>1,000 requests</td>
        </tr>
        <tr>
            <td>GET</td>
            <td>$0.01</td>
            <td>10,000 requests</td>
        </tr>
    </tbody>
</table>

###Reduced Redundancy Storage

Couple things to note about RRS. It's cheaper, obviously, however it's not guaranteed to be available 24/7. You may experience a higher dataloss rate with RRS than you would with Standard. However, if the data you're hosting on RRS isn't critical and can easily be replaced then you're best bet is to host it there. RRS has a 99.99% durability guarantee while the Standard has a 99.999999999%. The durability guarantee is covered by Amazon's SLA with refunds when applicable. 

###Buckets

S3 starts with the concept of a Bucket. 

<div style='text-align:center;'><a href='http://aws.buildstarted.com/s3/bucketlist.png'><img src='http://aws.buildstarted.com/s3/bucketlist.png' /></a></div>

I currently have two buckets - the first one I'll explain later. The second one is just a personal bucket that I posted for testing. Bucket files can generally be accessed via a simple url <strong>https://s3.amazonaws.com/Bucket Name/File name.extension</strong>. You may also add folders to your bucket in the same way. One thing I'm not sure about is whether or not Bucket Names must be unique across the board, given the url it seems necessary and I haven't come across any issues with it yet.

So far, it seems, you can have any number of sub directories within your bucket as well as any number of files. I haven't really tested this thoroughly and I don't need to really since it serves my current purposes and I doubt I'll need more than a few hundred files per directory - let alone a few thousand.

###Uploading Files

<div style='text-align:center;'><a href='http://aws.buildstarted.com/s3/uploadfiles.png'><img src='http://aws.buildstarted.com/s3/uploadfiles.png' style='width:100%;' /></a></div>

The file upload screen is just as standard as any other I'm sure you've worked with. The main thing to notice is the ability to select where your files will be hosted. Standard or Reduced Redundancy Storage.

<div style='text-align:center;'><a href='http://aws.buildstarted.com/s3/uploadfilepermissions.png'><img src='http://aws.buildstarted.com/s3/uploadfilepermissions.png' style='width:100%;' /></a></div>

You can also set file permissions while uploading. This saves an extra few steps later as this can all be done on  one screen vs. going through all your files later. There are more fine-grained permissions that you could apply here as well but I haven't really gone through them well enough to post here.

###Files

<div style='text-align:center;'><a href='http://aws.buildstarted.com/s3/s3filelist.png'><img src='http://aws.buildstarted.com/s3/s3filelist.png' style='width:100%;' /></a></div>

The Filelist is very much like any other file explorer you've used so there doesn't seem to be any learning curve here. 

You can view file details such as size, and the Url of where the file is currently located. On the next tab you can see all the permissions. There really isn't much to do here really. Just nice to be able to modify it quickly and easily.

<div style='text-align:center;'><a href='http://aws.buildstarted.com/s3/filedetails.png'><img src='http://aws.buildstarted.com/s3/filedetails.png' style='width:100%;' /></a></div>

<div style='text-align:center;'><a href='http://aws.buildstarted.com/s3/filepermissions.png'><img src='http://aws.buildstarted.com/s3/filepermissions.png' style='width:100%;' /></a></div>

<div style='text-align:center;'><a href='http://aws.buildstarted.com/s3/filemetadata.png'><img src='http://aws.buildstarted.com/s3/filemetadata.png' style='width:100%;' /></a></div>

The metadata tab is a nice feature though Amazon has correctly guessed all the file-types I've uploaded.

##CloudFront

If you have a large audience, with locations around the globe, you may want to utilize Cloudfront to distribute your files. This has the advantage of low latency and high transfer speeds and makes you look better to your customers. It's a win-win.

Costs:

<table id='s3'>
    <thead>
        <tr>
            <th>Outbound Transfers</th>
            <th>Pricing Per Gigabyte</th>
        </tr>
    </thead>
    <tbody>
        <tr class='highlight'>
            <td>First 10 TB</td>
            <td>$0.15</td>
        </tr>
        <tr>
            <td>Next 40TB</td>
            <td>$0.10</td>
        </tr>
        <tr>
            <td>Next 100TB</td>
            <td>$0.08</td>
        </tr>
        <tr>
            <td>Next 100TB</td>
            <td>$0.07</td>
        </tr>
        <tr>
            <td>Next 250TB</td>
            <td>$0.06</td>
        </tr>
        <tr>
            <td>Next 250TB</td>
            <td>$0.05</td>
        </tr>
        <tr>
            <td>Next 250TB</td>
            <td>$0.04</td>
        </tr>
        <tr>
            <td>Over 1000TB</td>
            <td>$0.03</td>
        </tr>
    </tbody>
</table>

Requests:

<table id='s3'>
    <thead>
        <tr>
            <th>Requests</th>
            <th>Pricing Per 10,000 Requests</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>HTTP Requests</td>
            <td>$0.0075</td>
        </tr>
        <tr>
            <td>HTTPS</td>
            <td>$0.01</td>
        </tr>
    </tbody>
</table>

The first step is to create a <strong>Distribution</strong>.

<div style='text-align:center;'><a href='http://cloudfront.buildstarted.com/cloudfront/cloudfrontdistribution.png'><img src='http://cloudfront.buildstarted.com/cloudfront/cloudfrontdistribution.png' /></a></div>

The Origin is where your files will be retrieved when the Cloudfront server doesn't have them already loaded. The files are cached and removed every 24 hours. You can change this on the Origin server by having your origin server alter the <em>cache-control</em> header to change it to a much larger timeout if your files don't need to be refreshed often.

<div style='text-align:center;'><a href='http://cloudfront.buildstarted.com/cloudfront/cache-control.png'><img src='http://cloudfront.buildstarted.com/cloudfront/cache-control.png' style='width:100%;' /></a></div>

You should leave CNAME blank for now since you can't do anything with it until <em>after</em> you get your randomly assigned domain name.

For now you should make your Distribution disabled as it takes a while to actually deploy your new distribution. Then you'll see something like: 

<a href='http://cloudfront.buildstarted.com/cloudfront/overview.png'><img src='http://cloudfront.buildstarted.com/cloudfront/overview.png' style='width:100%;' /></a>

When you're all ready and have setup everything go ahead and press "Enable" - it will take about 15 minutes to deploy your setup and you're all done. 

##CNAMEs

One of the great features of Amazon's services is the ability to CNAME their default domain.
Cloudfront gives you a randomly assigned domain - such as mine: <strong>d1phkhug8d4y65.cloudfront.net</strong>. That's not very friendly to remember and looks horrible if you give that link to someone. So just go to your DNS provider and add a CNAME record and point it to your cloudfront domain or your S3 bucket name. For this example I've chosen <strong>aws.buildstarted.com</strong> as my S3 CNAME and cloudfront.buildstarted.com as my Cloudfront domain. If you look, you'll see that I'm using both of these new domains on this particular post. The Cloudfront images are hosted on my cloudfront domain, while the S3 images are hosted on my aws domain. One thing to note, while you have to tell Cloudfront what CNAMEs you'll be using S3 has no such feature. You have to specify your domain as your Bucket Name. That's why I named my S3 bucket <strong>aws.buildstarted.com</strong>. That's my CNAME domain. If you do not register your bucket name like that then CNAMEs will not work.

##Final

I hope this gives everyone another small glimpse into what is possible with Amazon's services. I hope to post more of these in the coming month or so as I get more and more familiar with their product. 

###Ben