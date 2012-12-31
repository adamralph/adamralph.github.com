---
layout: post
title: Routing problems by not providing default route values
---

While working on a new site that uses <a href='http://haacked.com/'>Phil Haack</a>'s <a href='http://routemagic.codeplex.com/'>RouteMagic</a> I came across a curious thing. All my <strong>Html.ActionLink</strong> calls were routing to a controller/action that they shouldn't route to. I fired up <a href='http://getglimpse.com/'>Glimpse</a> to see what routes were possible matches to try and find the culprit. (The route exists in an external library) Here's an example: 

    @Html.ActionLink("Log on", "LogOn", "Account")

This would normally route to <strong>/account/logon</strong> however if you have a <strong>routes.MapDelegate</strong> call that has no <strong>{parameters}</strong> it will match every time.

Given the following routes

    routes.MapDelegate("RouteFailureTest", "home/test", context => new HomeController().HomeTest(context.HttpContext));

    routes.MapRoute(
        "Default", // Route name
        "{controller}/{action}/{id}", // URL with parameters
        new { controller = "Home", action = "Index", id = UrlParameter.Optional }//, // Parameter defaults
    );

a call to <strong>@Html.ActionLink("Log Off", "Logout", "User")</strong> always matches the "RouteFailureTest".

After checking the source code from Codeplex I can see that no default route values are specified in the call (here is the source from RouteMagic)

    public static Route MapHttpHandler(this RouteCollection routes, IHttpHandler httpHandler, string name, string url, object defaults, object constraints) {
        var route = new Route(url, new HttpHandlerRouteHandler(httpHandler));
        route.Defaults = new RouteValueDictionary(defaults); //I believe this is where the problem lies
        route.Constraints = new RouteValueDictionary(constraints);
        routes.Add(name, new NormalizeRoute(route));
        route.SetRouteName(name);
        return route;
    }


Since <strong>Html.ActionLink</strong> and it's brethren supply their own Controller/Action values my thoughts were that the lack of values in the route caused it to match. To confirm this is the case I created another standard route with null as it's default parameter values.

    routes.MapRoute(
        "ShouldntMatch", // Route name
        "home/test", // URL with parameters
        null // Parameter defaults
    );


This caused the same issue as <strong>RouteMagic</strong>'s <strong>MapDelegate</strong>.

Normally all routes have default values but <strong>MapDelegate</strong> tells the router exactly where it should go to handle a particular route. This means that it bypasses the <strong>DefaultControllerFactory</strong> which utilizes the route values to determine where the url should route to. This would normally be fine except for the way that ActionLink determines which route to format the url after.

There really doesn't seem to be much that we can do to get around this except to provide a default to the <strong>MapDelegate</strong> route that will never hit.

    var route = routes.MapDelegate("RouteFailureTest", "home/test",
        context => new HomeController().HomeTest(context.HttpContext));

    route.Defaults = new RouteValueDictionary(new { controller = "thisisacontrollerthatwillneverhit", action = "thisisanactionthatwillneverhit" });

This is such an interesting case. It relies on the fact that the route has <strong>no</strong> default controller, action or parameters such as {id}. Yet it breaks a lot of other MVC functions that rely on routes having those values. For now I've hard coded the particular issue I have with this and replace other <strong>Html.ActionLink</strong>s with <strong>Html.RouteLink</strong> but this is only a temporary solution until either Phil Haack can resolve it or I can find another solution. For now I'm modifying the specific route that is causing problems with the unhittable controller/action. It seems to work but I definitely can't rely on it.

###- Ben Dornis