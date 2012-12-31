---
layout: post
title: Why you should care about Parrot a new Asp.net mvc view engine
---

This post highlights some of the main features of what Parrot is with a little detail thrown in.

###Test drive

I have a <a href="http://testdrive.thisisparrot.com/">test drive</a> page that allows you to try out Parrot from your browser. Note that the test drive actually uses the alpha bits available for download from Nuget to render pages. It's a work in progress (standard Works On My Machine disclaimer) but it really helps demonstrate how Parrot works.

<a href="http://testdrive.thisisparrot.com/"><img src="https://a248.e.akamai.net/camo.github.com/7dded2d4f58f34f104ab8a1c1d34410162fea184/687474703a2f2f6177732e6275696c64737461727465642e636f6d2f746573742d64726976652e706e67" alt="Parrot's Test Drive" title="&quot;Parrot's Test Drive&quot;" style="max-width:100%;"></a>

##Simplicity

Creating a clean view is very simple. Much of the fluff has been removed and you're left with only what you need to define the document. Html can be verbose and an attempt has been made to minimize the amount of text needed to define a document to what is necessary. To that end I've decided to use the css selector syntaxes. I'm going to show you a sample of html then Parrot and then a short-hand Parrot (that works only for divs)

    <div id="some-id"></div>

    div#some-id

    #some-id

They all produce the same output. Notice the cleaner syntax of Parrot. I think it allows more of a focus on the structure of the html and how models interact.

##Model support

The default html renderers that ship with Parrot.Mvc have great model support. Automatically scoped variables as well as support for IEnumerables.

###Scoped variables

By default variables are scoped based on their nearest parent with a parameter (defaults to the passed in model). As you traverse down the children the model values are automatically mapped to a property of the parent model parameter

    var model = new 
    {
        User = new 
        {
            Name = "Buildstarted",
            Location = "Los Angeles"
        }
    };

    div(User)
    {
        label> "Name"
        span(Name)
        label > "Location"
        span(Location)
    }

You can see in the above code that we didn't have to tell the span  style="display:inline;">Model.User.Name when we wanted to output the value. We just had to tell it name. When a model value is resolved it looks for a property on the parent that matches and will output that. Likewise the default model for all elements is `this` which is the same as `Model`

###IEnumerable support

IEnumerable support was something I wanted to include as a default thing in Parrot. Any time an element definition includes an IEnumerable as the first parameter and has children it will automatically loop over the parameter and create the child definition passing current element as a parameter to it. This is great for `ul`, `ol`, `tbody` and so forth. To illustrate this let's take a `List<string>` and pass it into a ul element.

    var model = new 
    {
        Authors = new List<string>
        {
            "Ray Bradbury", 
            "Harry Harrison", 
            "Douglas Adams",
            "Isaac Asimov", 
            "Arthur C. Clarke" 
        }
    };

    ul(Authors) {
        li(this)
    }

    <ul>
        <li>Ray Bradbury</li>
        <li>Harry Harrison</li>
        <li>Douglas Adams</li>
        <li>Isaac Asimov</li>
        <li>Arthur C. Clarke</li>
    </ul>


Note the parameter for `li` is `this` because the element we want to output is the current item in the list. If this were a property we wanted to output like `Name` we would just use `li(Name)` or `li > :Name`. By default all html elements support IEnumerable parameters. Some, such as any self closing element, will ignore the parameter.

##Renderers

Renderers are the heart and soul of Parrot. The grammar is just a vehicle to the renderers. Every single element and any custom element can have it's own renderer leading to a lot of control over the output. This also allows for a lot of flexibility. Model support, in addition, is entirely a function of the renderers. You could technically have renderers that require fully qualified model properties.

Bottom line: Parrot view engine is built from renderers, and you can easily write your own renderers to add keywords that extend the language however you'd like.

Creating a new renderer is as easy as implementing an interface and adding your new class to a `RendererFactory`. Any time the renderer comes across an element it will query the RenderFactory for it's renderer and use it to parse the block.

There are currently several custom renderers including a renderer that supports a `layout` view, `foreach` and `doctype`.

    //child view
    layout("viewname") {
        ...content goes here...
    }

    //layout view
    html > body {
        content
    }

Renderers can also override the default element for short-cut statements. For instance the following will not output the `div` but will instead output `li`

    ul(Authors) > .item(this)
    <ul>
        <li class="item">Ray Bradbury</li>
        ...
    </ul>

###Future posts

I'm going to go into more detail about the grammar in a future blog post as well as go into details about creating a custom renderer and how the rendererfactory works.

###Nuget

I'll try to go into detail on each feature of Parrot as questions come in. But in the mean time you can try out Parrot for yourself. The alpha bits are available on <a href="http://nuget.org/packages?q=Parrot">Nuget</a>. You can ask questions on <a href="http://jabbr.net">Jabbr</a> in the <a href="http://jabbr.net/#rooms/parrot">Parrot</a> room. I'll answer them when I can. You can always bug me on <a href="http://twitter.com/Buildstarted">Twitter</a>.

<strong>-Ben Dornis</strong>