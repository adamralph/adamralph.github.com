---
layout: post
title: Jang and server sideclient side view engine for mvc and javascript
---

<div style="background-color: #202020; border: 4px solid #C0C0C0;border-radius: 5px 5px 5px 5px;box-shadow: 2px 2px 3px #6E6E6E;color: #E2E2E2;display: block;font: 1.5em 'andale mono','lucida console',monospace; overflow: auto; padding:15px; margin-bottom: 1.5em;"><p style="margin-bottom:0;">PM&gt; Install-Package Jang</p></div>

Jang was born out of a desire to have a single template that works on both server and client side using any view engine necessary. 
For instance an ajax site that polls for a new comment and inserts it into the page without a post back you'll have to maintain two views
one for the server-side generation of the initial page and one for the client-side rendering with an ajax call. 

Jang makes it easier to have the best of both worlds. With a single call you can render the same view on the server, while at the same time make a call
on the client and render the same view with new data.

##Example
Here is a sample view that generates a list of users from a model.
    //userlist.jazz
    <ul>
        @for(var i in model.Model) &#123;
            @jang.renderView("user", model.Model[i])
        }
    </ul>
    //user.jazz (this is a child view)
    <li>@model.Model.Name</li>


##Server-side Views
Rendering a view on the server side is almost no different from how you render child views in Razor.

    @Html.RenderTemplate(viewName, Model)

This can be done almost anywhere you currently call child views.
    
##Client-side Views
There are two ways to render a client-side view.

Direct call

    jang.renderView("user", model)

    
This will return the html of the rendered view which you can then use to insert into the dom.

Making an ajax call with jang.ajax will automatically render the view for you and return the resulting html.

    jang.ajax(&#123;
        url: '/home/user',
        success: function (result) &#123;
            $("ul#users").append($(result));
        }
    });


On the server side you need to return a proper response for the view to be rendered. A "JangResult" object has been provided to make this easy.

    public ActionResult User()
    &#123;
        return new JangResult(new User &#123;Name = "this is a new user "});
    }


The JangResult automatically determines the view name based on the action or you can specify a different one yourself.

The goal was to make this seamless and invisible to the consumer.

##View Engines
Jang was designed to support additional view engines. Support exists for jsRender, Underscore, Mustache and Jazz. (Jazz is currently still in alpha)

The above sample can be translated:

###Underscore
    
    //userlist.underscore
    <ul>
	<% for(var index = 0; index <Model.length; index++) &#123;%>
		<%= jang.renderView("user", Model[index]) %>
	<%}%>
    </ul>
    //user.underscore (this is a child view)
    <li><%= Model.Name %></li>
	
###jsRender

    //userlist.jsrender
	<ul>
		&#123;&#123;#each Model}}
			<li>&#123;&#123;=Name}}</li>
		&#123;&#123;/each}}
	</ul>

###Mustache

    //userlist.mustache
	<ul>
		&#123;&#123;#Model}}
			<li>&#123;&#123;Name}}</li>
		&#123;&#123;/Model}}
	</ul>

The source for this project is hosted on Github at <a href="https://github.com/Buildstarted/Jang" title="https://github.com/Buildstarted/Jang">https://github.com/Buildstarted/Jang</a> please fork it and add support for more view engines :)

I'll have a future post detailing how it all works.

- <strong>Ben Dornis</strong>