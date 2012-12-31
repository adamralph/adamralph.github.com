---
layout: post
title: Razor engine v2.x
---

##The RazorEngine

The <a href='http://razorengine.codeplex.com/'>RazorEngine</a> was developed primarily by Matthew Abbott at <a href='http://fidelitydesign.net'>fidelitydesign.net</a>. The project originally started <a href='http://buildstarted.com/2010/09/29/razor-view-engine-without-mvc-at-all/'>here</a> but Matthew took it to a whole new level and made it full of awesome. 

With that little into I'm going to get into what the Razor Engine can do for you.

The Razor Engine is available from <a href='http://razorengine.codeplex.com/'>codeplex.com</a> or you can use <a href='http://nuget.org/Packages/Packages/Details/RazorEngine-2-1'>NuGet</a> (recommended because it's just awesome). There's only the one <strong>RazorEngine.dll</strong> and it requires <strong>System.Web.Razor</strong> for the default parser. Part of me thinks that the Razor Parser should be removed from the System.Web namespace since it has applications outside of the web but I gather its primary focus is that of an html/c# parser not a generic parser.

##Quick Tutorial

For those of you unfamiliar with razor here's a quick sample that will hopefully help you to understand why it rocks. 

    <ul>
        @foreach(Author author in Model.CoolAuthors) {
            <li>@author.Name</li>
        }
    </ul>


The output generated would be simply

    <ul>
        <li>David Brin</li>
        <li>William Gibson</li>
        <li>Gene Wolfe</li>
        <li>C. J. Cherryh</li>
    </ul>


This makes authoring xml/html a million times cleaner than the old <span style='background-color:yellow; font-weight:bold;'>&lt;% %&gt;</span> method. You'll notice that the parser figured out that the <strong>@</strong> symbol was a transition between html and c#. You'll notice I don't have an <strong>@</strong> symbol in front of my last } there. Since the parser knows c# pretty well it's able to figure out when the code ends and html begins again. 

<a href='http://weblogs.asp.net/scottgu/archive/2010/12/15/asp-net-mvc-3-razor-s-and-lt-text-gt-syntax.aspx'>Scott Guthrie</a> has a good set of posts about razor if you'd like to learn more.

##Sample RazorEngine Implementation

The Razor Engine was designed to be as simple as can be to call in your application. One call and the base template can handle most of your needs.

    string template = "Hello @Model.Name! Welcome to Razor!"
    string result = Razor.Parse(template, new { Name = "World" });


In the above template you're passing in your template - which can be pulled from anywhere - and an object that will represent your model. In this case, an anonymous type with the Name property.

All RazorEngine derived objects inherit from <strong>TemplateBase</strong>. This class has only one property that you need to worry about and that is <strong>Model</strong>. This is the object that will contain the object you pass in to the template. As in the above example it was the Anonymous type. You may, however, wish to add your own methods. One example provided by the codeplex documentation is a <strong>ToUpperCase</strong> function. To implement this you would inherit <strong>TemplateBase&lt;T&t;</strong>

    public abstract class MyCustomTemplateBase<T> : TemplateBase<T> {
        public string ToUpperCase(string name) {
            return name.ToUpperCase();
        }
    }


To utilize your new TemplateBase you must initialize it within the RazorEngine. `Razor.SetTemplateBase(typeof(MyCustomTemplateBase<>));` This <strong>must</strong> be the first call you make. Usually within <strong>Application_Start</strong> or <strong>main</strong> or some other initialization method. This is a static method and as such this affects <strong>all</strong> calls to the RazorEngine.

To call your new method within your razor files: 

    string template = "My name in UPPER CASE is: @ToUpperCase(Model.Name)";
    string result = Razor.Parse(template, new { Name = "Ben" });


##Configuration

Please read the <a href='http://razorengine.codeplex.com/wikipage?title=Using%20Configuration&amp;referringTitle=Documentation'>documenation</a> available on codeplex.com as it is very complex and would require a blog post on it's own.

##Medium Trust

Last, but not least, Matthew Abbott has worked very hard to get it to work in Medium Trust. This only works for web applications as it utilizes the built in asp.net buildprovider. To add support for medium trust you'll need to download the <a href='http://nuget.org/Packages/Packages/Details/RazorEngine-Web-2-1'>RazorEngine.Web</a> reference to your project and <a href='http://razorengine.codeplex.com/wikipage?title=Configuring%20RazorEngine%20for%20ASP.NET%20Medium%20Trust&amp;referringTitle=Documentation'>configure</a> it as well

##Issues you may come across

The Razor Engine is the same parser technology used with the MVC Razor Parser, however, the MVC parser has added functionality to it as a result of using a the <strong>System.Web.Mvc.ViewPage</strong> base class which adds a bunch of helper methods such as <strong>Html.</strong> and <strong>Url.</strong>. So keep this in mind when utilizing the Razor Engine as you will not have those methods available to you - unless you use a different base template other than <strong>TemplateBase</strong>.

Currently the Razor Engine does not support inline delegates such as

    @List.ForEach(i => { @* Some Complex stuff *@ });


Which is a shame, but I've been told by Andrew Nurse that it's in the works.

##Conclusion

The RazorEngine is a really nice template engine that I currently use in my day-to-day work environment. Adding features as I go to the engine for personal use. Sometimes those features make it into the real engine. Sometimes they don't. Just depends on how useful they are and whether or not they make sense for the overall project. I hope you get as much use out of it as I do. 

###- Ben Dornis