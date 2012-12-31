---
layout: post
title: Mvc htmlhelper that generates a menu from a controller
---

Simple menu system that grabs a list of actions from a single controller and creates an unordered list of links. To accomplish this I've created an attribute that will be applied to the action methods we want to see in the menu

    public class MenuItemAttribute : Attribute {
        public int Index { get; set; }
    
        public MenuItemAttribute() {
            Index = 0;
        }
    
        public MenuItemAttribute(int Index) {
            this.Index = Index;
        }
    }


Simple and to the point. Here's an example of usage.

    [MainMenuItem(0)]
    [Display(Name = "Home")]
    public ActionResult Index() {
        return View();
    }


##Page navigation

The following method is an HtmlHelper Extension that will find a controller's type and grab all the methods that have our MenuItem attribute. In addition we check for the ActionNameAttribute in case the users specified a different action such as /Home/index-page. If the method name isn't really conducive to a menu name we can change it by checking for the Display attribute. After we have our list of methods we create a ul>li>a list and return.

The Menu() extension has several parameters such as htmlAttributes for each of the elements and also a parameter to set different attributes on the active item (the current page).

    public static MvcHtmlString Menu(
        this HtmlHelper helper,
        string Controller,
        object ulHtmlAttributes,
        object liHtmlAttributes,
        object activeHtmlAttributes) {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        var controllerMethods = Assembly.GetExecutingAssembly().GetTypes()
            .Single(t => t.IsSubclassOf(typeof(Controller)) && t.Name.StartsWith(Controller)).GetMembers()
            .Where(c => c.GetCustomAttributes(true).Where(a => a.GetType() == typeof(MenuItemAttribute)).Any())
            .Select(c => new {
                action = (c.GetCustomAttributes(true).Where(a => a.GetType() == typeof(ActionNameAttribute)).Any()
                    ? ((ActionNameAttribute)c.GetCustomAttributes(true).Single(a => a.GetType() == typeof(ActionNameAttribute))).Name
                    : c.Name),
                display = (c.GetCustomAttributes(true).Where(a => a.GetType() == typeof(DisplayAttribute)).Any()
                    ? ((DisplayAttribute)c.GetCustomAttributes(true).Single(a => a.GetType() == typeof(DisplayAttribute))).Name
                    : c.Name),
                index = (n.GetCustomAttributes(true).Where(a => a.GetType() == typeof(MenuItemAttribute)).Any()
                    ? ((MenuItemAttribute)n.GetCustomAttributes(true).Single(a => a.GetType() == typeof(MenuItemAttribute))).Index
                    : 0)
            }).OrderBy(c => c.index);

        var ul = new TagBuilder("ul");
        ul.MergeAttributes<string, object>(new RouteValueDictionary(ulHtmlAttributes));
        var li = new List<TagBuilder>();
        foreach (var c in controllerMethods) {
            var l = new TagBuilder("li") {
                InnerHtml = System.Web.Mvc.Html.LinkExtensions.ActionLink(helper, c.display, c.action).ToString()
            };
            l.MergeAttributes<string, object>(new RouteValueDictionary(liHtmlAttributes));
    
            if (Controller == (string)helper.ViewContext.RouteData.Values["controller"] &&
                c.action == (string)helper.ViewContext.RouteData.Values["action"] &&
                activeHtmlAttributes != null) {
                l.MergeAttributes<string, object>(new RouteValueDictionary(activeHtmlAttributes));
            }
    
            li.Add(l);
        }
        ul.InnerHtml = string.Join("", li);
    
        return MvcHtmlString.Create(ul.ToString(TagRenderMode.Normal));
    }


##Site Navigation

For something like a Main navigation menu we might want to grab menu items from all sorts of controllers. This made the Query quite a bit more complicated but still produces the same results. The difference here is that I made a MainMenuItemAttribute to differentiate the two menu types.

    public static MvcHtmlString MainMenu(this HtmlHelper helper, object ulHtmlAttributes, object liHtmlAttributes, object activeHtmlAttributes) {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
    
        var controllerMethods = Assembly.GetExecutingAssembly().GetTypes()
            .Where(t => t.IsSubclassOf(typeof(Controller)))
            .Where(con => con.GetMembers())
            .Where(cc => cc.GetCustomAttributes(true).Where(aa => aa.GetType() == typeof(MainMenuItemAttribute)).Any()).Count() > 0)
            .SelectMany(c => c.GetMembers())
                .Where(a => a.GetCustomAttributes(true).Where(aa => aa.GetType() == typeof(MainMenuItemAttribute)).Any())
                .Select( n => new {
                controller = c.Name.Replace("Controller", ""),
                action = (n.GetCustomAttributes(true).Where(a => a.GetType() == typeof(ActionNameAttribute)).Any()
                    ? ((ActionNameAttribute)n.GetCustomAttributes(true).Single(a => a.GetType() == typeof(ActionNameAttribute))).Name
                    : n.Name),
                display = (n.GetCustomAttributes(true).Where(a => a.GetType() == typeof(DisplayAttribute)).Any()
                    ? ((DisplayAttribute)n.GetCustomAttributes(true).Single(a => a.GetType() == typeof(DisplayAttribute))).Name
                    : n.Name),
                index = (n.GetCustomAttributes(true).Where(a => a.GetType() == typeof(MainMenuItemAttribute)).Any()
                    ? ((MainMenuItemAttribute)n.GetCustomAttributes(true).Single(a => a.GetType() == typeof(MainMenuItemAttribute))).Index
                    : 0)
            })).OrderBy(c => c.index);
    
        var ul = new TagBuilder("ul");
        ul.MergeAttributes<string, object>(new RouteValueDictionary(ulHtmlAttributes));
        var li = new List<TagBuilder>();
        foreach (var c in controllerMethods) {
            var l = new TagBuilder("li") {
                InnerHtml = System.Web.Mvc.Html.LinkExtensions.ActionLink(helper, c.display, c.action, c.controller ).ToString()
            };
            l.MergeAttributes<string, object>(new RouteValueDictionary(liHtmlAttributes));
    
            if (c.controller == (string)helper.ViewContext.RouteData.Values["controller"] &&
                c.action == (string)helper.ViewContext.RouteData.Values["action"] &&
                activeHtmlAttributes != null) {
                l.MergeAttributes<string, object>(new RouteValueDictionary(activeHtmlAttributes));
            }
    
            li.Add(l);
        }
        ul.InnerHtml = string.Join("", li);
    
        return MvcHtmlString.Create(ul.ToString(TagRenderMode.Normal));
    }


Sorry about the ugly code but I couldn't really find a way to make it look pretty on this site. 

###-Ben