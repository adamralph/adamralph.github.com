---
layout: post
title: Mvc 3 razor view engine without a controller
---

A question posted on stackoverflow caught my attention the other day that asked about using the Razor View Engine outside of MVC that would return a string value from a string template rather than a view...The code example was provided.

    string  myTemplate = "Hello @Name,  How are you today?";
    ViewModel.Name = "Billy Boy";
    string output = RazorViewEngineRender( myTemplate, ViewModel );


This particular solution didn't require the engine to exist outside of MVC so I relied on MVC to do a lot of the dirty work.

<strong>This is some ugly ugly code that was hacked together without testing it other than getting it to work properly.</strong>

##VirtualPathProvider

Since we're not dealing with actual views on the server we have to add our own path provider to tell MVC where to get our dynamically generated templates. There should be more tests like checking the strings Dictionary to see if the view has been added.

    public class StringPathProvider : VirtualPathProvider {
        public StringPathProvider()
            : base() {
        }

        public override CacheDependency GetCacheDependency(string virtualPath, IEnumerable     virtualPathDependencies, DateTime utcStart) {
            return null;
        }

        public override bool FileExists(string virtualPath) {
            if (virtualPath.StartsWith("/stringviews") || virtualPath.StartsWith("~/stringviews"))
                return true;

            return base.FileExists(virtualPath);
        }

        public override VirtualFile GetFile(string virtualPath) {
            if (virtualPath.StartsWith("/stringviews") || virtualPath.StartsWith("~/stringviews"))
                return new StringVirtualFile(virtualPath);

            return base.GetFile(virtualPath);
        }

        public class StringVirtualFile : System.Web.Hosting.VirtualFile {
            string path;
            public StringVirtualFile(string path)
                : base(path) {
                //deal with this later
                    this.path = path;
            }

            public override System.IO.Stream Open() {
                return new System.IO.MemoryStream(System.Text.ASCIIEncoding.ASCII.GetBytes(RazorViewEngineRender.strings[System.IO.Path.GetFileName(path)]));
            }
        }
    }


##Render Class

This class takes your template as a constructor parameter and adds it to a static Dictionary that is then read by the VirtualPathProvider above. You then call Render and you can optionally pass in a model. This will add the fully qualified model type to the @inherits and prepend that to the file contents.

    public class RazorViewEngineRender {
        internal static Dictionary&lt;string, string&gt; strings { get; set; }

        string guid;

        static RazorViewEngineRender() {
            strings = new Dictionary&lt;string, string&gt;();
        }

        public RazorViewEngineRender(string Template) {
            guid = Guid.NewGuid().ToString() + ".cshtml";
            strings.Add(guid, Template);
        }

        public string Render(object ViewModel) {
            //Register model type
            if (ViewModel == null) {
                strings[guid] = "@inherits System.Web.Mvc.WebViewPage\r\n" + strings[guid];
            } else {
                strings[guid] = "@inherits System.Web.Mvc.WebViewPage&lt;" + ViewModel.GetType().FullName + "&gt;\r\n" + strings[guid];
            }

            CshtmlView view = new CshtmlView("/stringviews/" + guid);

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.TextWriter tw = new System.IO.StringWriter(sb);

            ControllerContext controller = new ControllerContext();

            ViewDataDictionary ViewData = new ViewDataDictionary();
            ViewData.Model = ViewModel;

            view.Render(new ViewContext(controller, view, ViewData, new TempDataDictionary(), tw), tw);
            //view.ExecutePageHierarchy();

            strings.Remove(guid);

            return sb.ToString();

        }
    }


##Global.asax

    System.Web.Hosting.HostingEnvironment.RegisterVirtualPathProvider(
        new Controllers.StringPathProvider());


##Calling the code

    string Template = "Hello, @Model.Name";
    Models.User user = new Models.User() { Name = "Billy Boy" };
    RazorViewEngineRender view = new RazorViewEngineRender(Template);
    string Results = view.Render(user); //pass in your model


##Notes

This only works with typed Models. I attempted to pass in a new { Name = "Billy Boy" } and it's throwing errors. I'm not sure why and didn't really look too deeply into it. Before any of you ask, I did try to use the <strong><dynamic></strong> type. However it didn't seem to reflect properly. 

Anyway, this was a lot of fun. I'm definitely sure there are much better ways of doing this. Andrew Nurse has a nice blog post about using Razor outside of MVC entirely and I might revisit this in a later post and use that method.

###- Ben