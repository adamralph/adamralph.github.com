---
layout: post
title: The Parrot Grammar
---


#Creating an element

Creating an html element is really simple - just type a word. 

    div
    a
    ul
    some-random-name

These will create an html element (using the default html renderer) with the word as the tag.

    <div></div>
    <a></a>
    <ul></ul>
    <some-random-name></some-random-name>

#Adding an id or class to your new element

There are two ways to add an id or class declaration to your elements. We'll focus on the simple way in this example.

    div#sample-id

This will simply create an html element with the id tag set to "sample-id".

    <div id="sample-id"></div>


The same method is used for classes but with a . instead.

    div.sample-class
    <div class="sample-class"></div>

You may combine these two in one declaration. An element may only have <em>one</em> id tag but can have as many class declarations you'd like.

    div#sample-id.sample-class.other.info
    <div class="sample-class other info" id="sample-id"></div>

#Adding other attributes

Ids and classes aren't the only attributes you'll want to add. Adding additional attributes is simple. wrap a simple key/value pair with brackets. Multiple attributes can be added with a space in between. You can also add the id/class attributes here as well but it's not recommended.

    div[name="value"]
    div[name="firstname" data-val-id="something"]

    <div name="value"></div>
    <div name="firstname" data-val-id="something"></div>

#Adding children

There are two ways to add children. To add multiple children you'll usually want to wrap them in a parent using curly braces. To add a single child you can append it using the `>` syntax.

    ul {
        li
        li
        li
        li
    }

    div > a > span

    <ul>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
    </ul>

    <div><a><span></span></a></div>

#Adding siblings

Sometimes you don't need or want to wrap multiple children in curly braces. You can add siblings to an element by using the `+` selector syntax.

    ul > li + li + li + li

    <ul>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
    </ul>

#Model parameters

To bind an element to a model you just add it to the element declaration surrounded by parenthesis `()`.

    div(User)

This element is now bound to the User property of your model. This affects children properties as well and allows for simplified nesting.

    div(User) > span(FirstName) + span(LastName)

#String literals

There are several ways to output a string literal.

    span > | String that reads until newline character
    
    "String wrapped in quotes"
    
    @"String which doesn't
      care about newlines"
    
    'String wrapped in single quotes'
    
    @'Multiline string wrapped
        in single quotes'
    

#Variable outputs

There are two shortcuts to output a variable. If you pass in a variable to a block element and do not provide any children the variable with be added to the dom as with `ToString()` applied and added as the first child to that element. You can also encode output using `@` or raw output using `=`. (PageTitle = "Parrot")

    title(PageTitle)
    title > :PageTitle
    title > =PageTitle

    <title>Parrot</title>

#Shortcuts

You can shortcut divs by leaving div out when using #sample-id or .sample-class. 

    #sample-id
    <div id="sample-id"></div>

Some elements can override the default tag name such as a ul or ol. The default for these elements (as children) are li.

    ul > #sample-id
    <ul><li id="sample-id"></li></ul>

You can shortcut common attributes such as `type` as well. For instance when adding an input element you can specify it's type by adding a `:` followed by type.

    input:text
    input:radio
    
	<input type="text" />
    <input type="radio" />

#Parser

This is a very brief overview of the grammar for parrot. I don't anticipate any near-future changes. I am currently working on an alternative parser for the language to avoid a reference to GoldParser. I hope to have it released in the next couple weeks.

**-Ben Dornis**