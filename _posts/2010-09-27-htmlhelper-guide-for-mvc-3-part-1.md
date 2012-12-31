---
layout: post
title: Htmlhelper guide for mvc 3 part 1
---

When you spend a lot of time, like I do, using the Razor View Engine in MVC 3 you'll find yourself constantly looking up helper parameters. I've decided to put together this guide to help me, and others, to code more quickly and efficiently. This is part one of an n-part series involving all html helpers contained in MVC 3.

##AntiForgeryToken

AntiForgeryToken adds a hidden input element to your output that can then be verified on the server to validate that the form was generated from the server. The token a serialized string that is composed of an optional salt and the authenticated user, if available.

Validation occurs when the <strong>ValidateAntiForgeryToken</strong> attribute is attached to a class or action in a controller. It checks to make sure the input element <strong>and</strong> cookie are set, compares the two values, compares the salts contained in the value with the salt passed in the ValidateAntiForgeryToken and compares the username with the authenticated user. If any of these fails it throws a <strong>CreateValidationException</strong> which you can catch in the <strong>OnException</strong> override in the controller class.

###ValidateAntiForgeryToken Usage

    [ValidateAntiForgeryToken]
    public class HomeController : Controller { }

    [ValidateAntiForgeryToken(Salt="somerandomsalt")]
    public class HomeController : Controller { }

    public class HomeController : Controller {

        [ValidateAntiForgeryToken]
        public ActionResult Edit(FormCollection postData) {
        }
    }

    public class HomeController : Controller {

        [ValidateAntiForgeryToken(Salt="somerandomsalt")]
        public ActionResult Edit(FormCollection postData) {
        }
    }

###Html.AntiForgeryTokenUsage

    @Html.AntiForgeryToken()
    @Html.AntiForgeryToken("somerandomsalt")
    @Html.AntiForgeryToken("somerandomsalt", "cookiedomain", "cookiepath")

    <input name="&#95;&#95;RequestVerificationToken" type="hidden" value="DZ/jNEe1xi+vWLTnt384S+l+MR7bmo+39mtU6/q938vUdzBj9TJoTWC85LhyW2Sy" />
    <input name="&#95;&#95;RequestVerificationToken" type="hidden" value="NCUSPV2a8oYmb9HybwSlm/4fITS+tVM3fnNVn8NC23iUTQSdcuFKC7Fc1b6BlM9RkfZg79Pofu18Tuautk271A==" />
    <input name="&#95;&#95;RequestVerificationToken" type="hidden" value="NCUSPV2a8oYmb9HybwSlm/4fITS+tVM3fnNVn8NC23iUTQSdcuFKC7Fc1b6BlM9RkfZg79Pofu18Tuautk271A==" />


The output for the last two AntiForgeryToken calls result in the same values because the cookiedomain and cookiepath parameters only affect the HttpCookie and not the token itself.

##AttributeEncode

This method converts an object or string into an Html-encoded string. AttributeEncode only encodes <strong>&amp;</strong>, <strong>'</strong>, <strong>&lt;</strong> and <strong>"</strong> into their equivalent <strong>&amp;amp;</strong> <strong>&amp;#39</strong> <strong>&amp;lt;</strong> <strong>&amp;quot;</strong>

###Usage

    @Html.AttributeEncode("This will convert & \' < \" into html escaped characters.")

    @Html.AttributeEncode(SomeRandomObject)


The object overload of AttributeEncode will use the <strong>Convert.ToString</strong> method to create an InvariantCulture string and then AttributeEncode that.

##Encode

Encode is a more powerful version of AttributeEncode. It encodes all the same characters, however, it includes <strong>></strong> and quite a few international characters.

###Usage

    @Html.Encode("This will convert a number of different characters into html escaped characters.")

    @Html.Encode(SomeRandomObject)


The object overload performs the same as AttributeEncode's object overload.

##HttpMethodOverride

Html forms only support <strong>GET</strong> and <strong>POST</strong>. However, if you are writing your apps with REST in mind you'd like to have an action method look like

    [HttpDelete]
    public ActionResult DeleteEntry(int id)


You can still implement this in MVC by using HttpMethodOverride.

###Usage

    @using (Html.BeginForm("Delete", "Home", new { method = "Delete" })) {
        @Html.HttpMethodOverride(HttpVerbs.Delete)

        <input type="submit" value=" Delete " />
    }
    
    <form action="/Home/DeleteEntry/53" method="post">
        <input name="X-HTTP-Method-Override" type="hidden" value="DELETE" />
        <input type="submit" value=" Delete "  />
    </form>

The X-HTTP-Method-Override will inform MVC that this is actually a DELETE request and look for a method with the <strong>HttpDeleteAttribute</strong>.

These are all the Html helper methods that are not extension methods. Extension methods will be covered in the next post

###- Ben