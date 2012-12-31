---
layout: post
title: Introducing signalr eventstream
---

##SignalR.EventStream

Introducing a new favorite <a href="http://nuget.org">Nuget</a> package: <a href="https://nuget.org/packages/SignalR.EventStream">SignalR.EventStream</a>.

<div style="background-color: #202020; border: 4px solid #C0C0C0;border-radius: 5px 5px 5px 5px;box-shadow: 2px 2px 3px #6E6E6E;color: #E2E2E2;display: block;font: 1.5em 'andale mono','lucida console',monospace; overflow: auto; padding:15px; margin-bottom: 1.5em;"><p style="margin-bottom:0;">PM&gt; Install-Package SignalR.EventStream</p></div>

This is a live feed of the visitors to this site. Leave this page open and watch the live feed. <em>Previous visitors will show up in a few seconds.</em>

<em>Sample no longer available</em>

##SignalR.EventStream

SignalR.EventStream allows users to monitor events happening on the server, live. A single call can be made on the server and propagated to any number of clients. This library leverages the power of [SignalR](https://nuget.org/packages/SignalR) to make the client interface simple.

Born out of a desire to see when new users signed up on <a href='http://csharptube.com/'>http://csharptube.com/</a> without refreshing the user list and my familiarity with <a href="http://jabbr.net">Jabbr</a>.

##What can it be used for?

Some events you might be interested in viewing live.

1. User signups
1. Error notifications
1. Live user mapping (see above)
1. User notices such as when badges are awarded
1. Notice when customer makes a purchase
1. Update a page when a new comment is added
1. Update a vote count for rankings
1. Clearly the list is endless...

##That's all great but what is SignalR?

SignalR is a library developed by <a href="http://weblogs.asp.net/davidfowler/">David Fowler</a> and <a href="http://damianedwards.wordpress.com/">Damian Edwards</a> that allows asynchronous connections in ASP.Net that allows you to build real-time multi-user web applications. This basically means that you can <strong>execute server-side code directly from a client or execute javascript on the client directly from the server</strong>. It uses the best connection your browser can support. <a href='http://en.wikipedia.org/wiki/WebSocket'>WebSockets</a> and <a href='http://en.wikipedia.org/wiki/Push_technology#Long_polling'>LongPolling</a> with support for more coming soon.

<img src="http://aws.buildstarted.com/signalr-traffic.png" alt="Firebug showing the long polling requests" title="Firefox with long polling in firebug" />

##Authorize users to view events

There are two methods for streaming. One is <strong>Send(..)</strong> which sends an event to the "authorized" general group. The second method is <strong>SendTo(..)</strong> which sends an Event to a specific group of people. 

##EventStream.Send

The heart of this is that you should be able to send <strong>any</strong> data to the client and parse it via json. To enable this I'm using <a href="http://nuget.org/packages/Newtonsoft.Json">Newtonsoft.Json</a> to convert objects passed into a Json string which is then sent to the client. This allows for a lot of flexibility since the client can now handle anything we want. The event type is determined from the type of object passed in - except for anonymous types. You must pass in a specific event type in order to utilize it. Normal string events are typed as "event".

    public interface IEventStream
    {
        void Send(string @event);
        void Send(string type, object @event); //mainly used for anonymous types
        void Send(object @event);

        void SendTo(string group, string @event);
        void SendTo(string group, object @event);
        void SendTo(string group, string type, object @event);
    }


I throw an exception on anonymous types without a specified string type. One of the interesting gotcha's in c# is that there's no built in way to determine if a type is an anonymous one. Borrowing from another project I helped with, (<a href="https://github.com/Antaris/RazorEngine">RazorEngine</a>) I've pulled in the IsAnonymousType method.

    public static bool IsAnonymousType(Type type)
    {
        if (type == null)
            throw new ArgumentNullException("type");

        return (type.IsClass
                && type.IsSealed
                && type.BaseType == typeof(object)
                && type.Name.StartsWith("<>", StringComparison.Ordinal)
                && type.IsDefined(typeof(CompilerGeneratedAttribute), true));
    }


This has been a very reliable way of checking whether or not a particular type is an anonymous type.

##Usage

To send an event to the "authorized" group you simply make the following call.

    IEventStream EventStream = new EventStream();
    EventStream.Send("A simple string message");


You can easily handle this in javascript.

    (function() {
        var eventStream = new EventStream().connect();
        eventStream.eventReceived = function(type, data) {
            console.log(data);
        });
    })();


To send an event to a particular group you simply pass in the group you wish to send it to.

    IEventStream EventStream = new EventStream();
    EventStream.SendTo("message-group", "A simple string message");

If you just wait on this page all events will be captured and alerted. For more complex data, however.

    IEventStream EventStream = new EventStream();
    EventStream.Send(new UserSignup {
        Username = "Buildstarted",
        Realname = "Ben Dornis",
        BlogUrl = "http://buildstarted.com"
    });


SignalR.EventStream automatically builds a Json string and passes it to the clients.

    (function() {
        var eventStream = new EventStream().connect();
        eventStream.eventReceived = function(type, data) {
            /* Handle this more complex object */
        });
    })();


##Page specific sends

To make things easier to update pages I've added a <strong>PageStream()</strong> type in the eventStream.js. This uses the current pathname of the url as the group. You can then send events to any client currently viewing that page. This makes it really easy to add new comments or modify the rankings for a page.

    (function() {
       var pageStream = new PageStream().connect();
       pageStream.eventReceived = function(type, data) {
           //update the vote count!
       };
    });

    var path = new UrlHelper(ControllerContext.RequestContext).Action("index");
    new EventStream().SendTo(path, "this is a page update");


<em>I'm looking at how to create a path from the current request easier than that and externally to a Controller. (update forthcoming).</em>

You can use any simple javascript templating engine that handles json to automatically build an html object and insert it into the dom. 

You can find the source for SignalR.EventStream on <a href="https://github.com/Buildstarted/SignalR.EventStream">Github</a>.

--"[SignalR.EventStream] makes me want to look at SignalR"

<strong>-Ben Dornis</strong>