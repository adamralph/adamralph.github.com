---
layout: post
title: Razor templating on codeplex
---

Good news everyone! The Razor Templating project <a href='http://fidelitydesign.net'>Matthew Abbott</a> &amp; I have been working on is available on <a href='http://razorengine.codeplex.com/'>Codeplex.com</a>! 

###Project Description

A templating engine built upon Microsoft's Razor parsing technology. The Razor Templating Engine allows you to use Razor syntax to build robust templates. Currently we have integrated the vanilla Html + Code support, but we hope to support other markup languages in future.

Using the templating engine couldn't be easier, using a simple synax, we can do the following:

    string template = "Hello @Model.Name! Welcome to Razor!"
    string result = Razor.Parse(template, new { Name = "World" });


The templating engine supports strict and anonymous types, as well as customized base templates, for instance:

    Razor.SetBaseTemplate(typeof(HtmlTemplateBase<>));

    string template = 
    @"<html>
        <head>
          <title>Hello @Model.Name</title>
        </head>
        <body>
          Email: @Html.TextBoxFor(m => m.Email)
        </body>
      </html>";

    var model = new PageModel { Name = "World", Email = "someone@somewhere.com" };
    string result = Razor.Parse(template, model);


I hope everyone enjoys this!

###- Ben