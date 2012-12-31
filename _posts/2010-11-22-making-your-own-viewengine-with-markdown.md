---
layout: post
title: Making your own viewengine with markdown
---

Recently I was thinking about integrating the new <a href='http://buildstarted.com/2010/11/11/razor-templating-on-codeplex/'>Razor Templating Engine</a> into MVC so that I could learn how to create my own ViewEngine for MVC. However, I couldn't quite figure out exactly how to use it in anyway that would make it different from Razor itself. Instead I decided to use Markdown as I frequent <a href='http://stackoverflow.com'>Stackoverflow.com</a> quite a bit to try and help with questions related to Razor. (And get some answers for myself) It seemed like a good direction to go. Markdown is probably not a good idea though to use as a view in general.

##Markdown

First things first, I needed a Markdown parser for c#. Luckily <a href='http://code.google.com/u/wumpus1/'>Wumpus1</a> already created a <a href='http://code.google.com/p/markdownsharp/'>markdownsharp</a> library available on <a href='http://code.google.com'>Google Code</a>.

Markdown, somewhat, makes sense as a good sample as it's intended to take text, translate it to html, and display to the end user. It's also meant to be read without any translation...so this might work for some sort of user input where the end user doesn't need to know some complex markup language such as wikicode. I've added a list of locations to search by default to the <strong>MarkdownViewEngine</strong>.

##The ViewEngine

    public class MarkdownViewEngine : IViewEngine {
        #region IViewEngine Members

        string[] SearchLocations;

        ViewEngineResult FindPartialView(
            ControllerContext controllerContext, 
            string partialViewName, 
            bool useCache) {
        }

        ViewEngineResult FindView(
            ControllerContext controllerContext, 
            string viewName, 
            string masterName, 
            bool useCache) {
        }

        void ReleaseView(ControllerContext controllerContext, IView view) {
        }

        #endregion
    }


Above is the basic layout for all ViewEngines. Right now, we're only concerned with <strong>FindView</strong> as we can't implement PartialViews just yet without creating a real Markup parser to look for those. However, since it's easy enough to refactor these we're going to create a single <strong>CreateView</strong> method that handles both. 

##CreateView

The CreateView method is simple enough. We're going to return our MarkdownView in the ViewEngineResult. First, you need to find out what controllerName is being called in this request. The routeData in the controller context will contain that information so we can pull it out of there. Next we need to actually find our view. To do this I've created a GetViewPath method. Which in-turn calls <strong>FindPath</strong>. The FindPath method looks through our SearchLocations and attempts to find the file that contains our markdown. If I can't find the file I return a null which we then check for. If the path isn't null we return a new <strong>MarkdownView</strong> based on this file. Otherwise we return a ViewEngineResult that contains a list of the files we searched for.

    /// <summary>
    /// Meat of the FindView methods.
    /// </summary>
    /// <param name="controllerContext">The current controller context for this request.</param>
    /// <param name="viewName">The requested view name. </param>
    /// <param name="masterName">The master page view name (currently unused)</param>
    /// <param name="layoutPath">The layout path location (Replaces the masterpage in other view engines)</param>
    /// <param name="useCache">Cache the viewpage?</param>
    /// <remarks>The layout path is currently hardcoded to "Layout" and will look in the SearchLocations for that path</remarks>
    /// <returns>Returns a ViewEngineResult with the requested view</returns>
    public ViewEngineResult CreateView(
        ControllerContext controllerContext, 
        string viewName, 
        string masterName, 
        string layoutPath, 
        bool useCache) {
        //grab the current controller from the route data
        string controllerName = controllerContext.RouteData.GetRequiredString("controller");

        //for proper error handling we need to return a list of locations we attempted to search for the view
        string[] SearchedLocations;

        //get the actual path of the view - returns null if none is found
        string viewPath = GetViewPath(
        viewName, 
        controllerName, 
        out SearchedLocations);

        if (viewPath != null) {
            MarkdownView view = new MarkdownView(
        controllerContext, 
        viewPath, 
        layoutPath);
            return new ViewEngineResult(view, this);
        }

        //we couldn't find the view
        return new ViewEngineResult(SearchedLocations);
    }

    /// <summary>
    /// Look for the view in the current file system
    /// </summary>
    /// <param name="viewName">The name of the View you're looking for</param>
    /// <param name="controllerName">Current controller name</param>
    /// <param name="SearchedLocations">out a list of locations searched</param>
    /// <returns>A string value of the relative path</returns>
    public string FindPath(
        string viewName, 
        string controllerName, 
        out string[] SearchedLocations) {
        SearchedLocations = new string[SearchLocations.Length];

        for (int i = 0; i < SearchLocations.Length; i++) {
            string virtualPath = string.Format(
            SearchLocations[i], 
            viewName, 
            controllerName);

            SearchedLocations[i] = virtualPath;

            //check the active VirtualPathProvider if the file exists
            if (VirtualPathProvider.FileExists(virtualPath)) {
                //add it to cache - not currently implemented
                return VirtualPathProvider.GetFile(virtualPath).VirtualPath;
            }
        }

        return null;
    }


FindView just calls our CreateView method and passes in a function you'll see called <strong>GetLayoutPath</strong>. This function just calls FindPath method but only requires the ControllerContext as we've hard coded "Layout" as the view name.

    public ViewEngineResult FindView(
        ControllerContext controllerContext, 
        string viewName, 
        string masterName, 
        bool useCache) {
        return CreateView(
        controllerContext, 
        viewName, 
        masterName, 
        GetLayoutPath(controllerContext), 
        useCache);
    }

    /// <summary>
    /// Get the layout virtual path
    /// </summary>
    /// <param name="controllerContext">The current Controller context for this request</param>
    /// <returns>A string virtual path</returns>
    public string GetLayoutPath(ControllerContext controllerContext) {
        string[] locations;

    string controllerName = controllerContext.RouteData.GetRequiredString("controller");

        return FindPath("Layout", controllerName, out locations);
    }


There we have the basics of our ViewEngine. It looks for a file based on the View and Controller name and returns a MarkdownView result that will then be rendered to the writer.

##MarkdownView

The MarkdownView class only contains one interface method called <strong>Render</strong> which accepts a ViewContext and the writer we're going to render our html to. The MarkdownView requires just a few pieces of information the View and Layout partial paths. The render method is simple enough where we load the contents of the file, convert it and write it to the writer...can't go into too much detail with that one.

    /// <summary>
    /// Implements IView and renders a Markdown
    /// </summary>
    public class MarkdownView : IView {

        string ViewPath;
        string LayoutPath;

        public MarkdownView(string viewPath, string layoutPath) {
            this.ViewPath = viewPath;
            this.LayoutPath = layoutPath;
        }

        #region IView Members

        /// <summary>
        /// Converts markdown to html and writes it to the passed in writer
        /// </summary>
        /// <param name="viewContext"></param>
        /// <param name="writer"></param>
        public void Render(ViewContext viewContext, System.IO.TextWriter writer) {
            //View contents
            string contents = new StreamReader(VirtualPathProvider.OpenFile(ViewPath)).ReadToEnd();
            string layoutContents = LayoutPath == null 
            ? null 
            : new StreamReader(VirtualPathProvider.OpenFile(LayoutPath)).ReadToEnd();

            contents = Parse(contents);

            string output;
            output = layoutContents == null 
            ? contents 
            : layoutContents.Replace("__content__", contents);

            writer.Write(output);
        }

        /// <summary>
        /// Converts markdown to html
        /// </summary>
        /// <param name="markdown">Markdown text</param>
        /// <returns>Html formatted markdown text</returns>
        string Parse(string markdown) {

            MarkdownSharp.Markdown markdownSharp = new MarkdownSharp.Markdown(
                new MarkdownSharp.MarkdownOptions() {
                    AutoHyperlink = true,
                    AutoNewlines = true,
                    StrictBoldItalic = true
                });

            return markdownSharp.Transform(markdown);
        }

        #endregion
    }


##Layout.md

Since markdown, by default, doesn't render the opening and closing html tags and just renders what would essentially be the body, we have to wrap our markdown files in html. I've decided to go the simplistic route for now and just use the following

    <html>
        <head>
        </head>
        <body>
            __content__
        </body>
    </html>


<strong><em>_content</em>_</strong> will then be replaced with the rendered markdown.

##Putting it all together

All that's necessary now is to register our new ViewEngine with MVC. This can be accomplished by adding the following lines to our Global.asax.

    ViewEngines.Engines.Add(new MarkdownViewEngine());


This will tell MVC that we have an additional view engine to parse the request. Currently other ViewEngines will be checked first such as the razor or webforms view engines. If a handler can't be found it will then look at our new MarkdownViewEngine.

Our folder structure for the Markdown files is the same as any other view engine. The only difference is that we have a new <strong>.md</strong> file instead of <strong>.cshtml</strong> or <strong>.aspx</strong>.

<img src="http://aws.buildstarted.com/markdownviewengine.png" alt="The MarkdownViewEngine folder structure" title="The MardownViewEngine folder structure" />

##Final

Creating a custom view engine was fairly simple. I didn't deal with model in this particular instance as that would have seriously complexified the current goal. Especially since I would have to basically create a parser to figure out what is markdown and what would be code. I might save that for a later post though. Custom ViewEngines have other methods of access that don't necessarily have to rely on the file system for your views. I could have easily pulled the View from a database or even an embedded view in the project. There are quite a few possibilities. I hope you enjoyed this article and find it of use to you.

##-Ben