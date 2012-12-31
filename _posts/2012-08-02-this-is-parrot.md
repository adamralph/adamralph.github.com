---
layout: post
title: This is Parrot
---

For the past week and a half I've been working on a new view engine for Asp.Net MVC called <a href="https://github.com/Buildstarted/Parrot">Parrot</a>. (I chose the name because there were only 2 nuget packages that showed up with that name - and it sort of fit with what a view engine is. It repeats something but different.)

Parrot was designed to be similar to css. Something familiar that everyone should just be able to pick up without much knowledge. Here's a quick example.

    ul#phoneNumbers.phone(PhoneNumbers) {
        li[data-val-id=Id] {
            label(Type)
            span(Number)
        }
    }


Note the ul element is followed by an optional id and optional class declarations. There's an additional `(PhoneNumbers)` parameter. This tells us that the ul is bound to the model property `PhoneNumbers`. Since the model property is `IEnumerable` the engine automatically loops over the child template and applies the current enumerable element to it. If we had a model like the following:

    new {
         PhoneNumbers = 
         new [
             new { Id = 1, Type = "home", Number = "212 555-1234" },
             new { Id = 2, Type = "fax",  Number = "646 555-4567" }
         ]
     }


    <ul class="phone" id="phoneNumbers">
        <li data-val-id="1">
            <label>home</label>
            <span>212 555-1234</span>
        </li>
        <li data-val-id="2">
            <label>fax</label>
            <span>646 555-4567</span>
        </li>
    </ul>


Each element can have a custom renderer. This allows for extreme flexibility when it comes to what parrot does. Suppose you want to loop a bunch of divs but inlined with other elements. You can create your own renderer for a custom element name like `foreach`.

Now instead of looping within a ul it just outputs a list of divs. 

    foreach(PhoneNumbers) {
        div[data-val-id=Id] {
            label(Type)
            span(Number)
        }
    }

<script src="https://gist.github.com/3239182.js?file=ForeachRenderer.cs"></script>

You can even inject your own RendererFactory that will replace all renderers with something completely different. If you don't want to output html but instead want to output markdown or maybe html but raw with syntax highlighting or anything. Completely extensible.

This is just the start. The language is still going through refinements as different usage scenarios popup but the basic structure should remain the same.

You can download the source from Github <a href="https://github.com/Buildstarted/Parrot">here</a>. 

<strong>-Ben Dornis</strong>