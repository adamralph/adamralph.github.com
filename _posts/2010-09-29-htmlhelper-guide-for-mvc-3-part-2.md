---
layout: post
title: Htmlhelper guide for mvc 3 part 2
---

##Action

This method calls an action method and returns the result as a string. 

###Usage

    @Html.Action("actionName")
    @Html.Action("actionName", new { controller = "Home", id="value" })
    @Html.Action("actionName", "controllerName")
    @Html.Action("actionName", new RouteValueDictionary(new { controller="Home", id="value"}))
    @Html.Action("actionName", "controllerName", new { id= "value" })
    @Html.Action("actionName", "controllerName", new RouteValueDictionary(new {id="value"}))


Each Action call executes the appropriate action and returns a string. The actual output is dependent on the view.

##Render Action

This method calls an action method and outputs the result inline with the parent

    @{ Html.RenderAction("actionName"); }
    @{ Html.RenderAction("actionName", new { controller = "Home", id="value" }); }
    @{ Html.RenderAction("actionName", "controllerName"); }
    @{ Html.RenderAction("actionName", new RouteValueDictionary(new { controller="Home", id="value"})); }
    @{ Html.RenderAction("actionName", "controllerName", new { id= "value" }); }
    @{ Html.RenderAction("actionName", "controllerName", new RouteValueDictionary(new {id="value"})); }


Each RenderAction call executes the appropriate action and outputs the resulting view directly to the response inline with the existing view. As these are void methods you must put the calls within a @{ } codeblock rather than just @.

##Display

This method returns and html representation of an object value.

###Usage

    @Html.Display("ModelObject")
    @Html.Display("ModelObject", new { Value="Test" })


##DisplayFor

Renders objects as html. This is overridable by providing your own templates.

###Usage

    @Html.DisplayFor(model => model)
    @Html.DisplayFor(model => model.property)
    @Html.DisplayFor(model => model.property, new { id = "some value" })
    @Html.DisplayFor(model => model.property, "AlternateTemplateName")
    @Html.DisplayFor(model => model.property, "AlternateTemplateName", new { id = "some value" })
    @Html.DisplayFor(model => model.property, "AlternateTemplateName", "htmlFieldName")
    @Html.DisplayFor(model => model.property, "AlternateTemplateName", "htmlFieldName", new { id = "some value" })


###Results

Results depend on the templates for the particular model you've passed in. "AlternateTemplateName" is a template you create for your particular model. HtmlFieldName is for when you are using a template for a single field you can specify an alternate name.

<a href='http://buildstarted.com/2010/09/10/overriding-displayfor-and-editorfor-to-create-custom-outputs-for-mvc/'>More Detail</a> about custom templates in my previous post.

##DisplayForModel

Same as DisplayFor but focuses on the model itself and does not accept any parameters for individual elements for a model.

###Usage

    @Html.DisplayForModel()
    @Html.DisplayForModel(new { id = "some value" })
    @Html.DisplayForModel("AlternateTemplateName", new { id = "some value" })
    @Html.DisplayForModel("AlternateTemplateName", "htmlFieldName")
    @Html.DisplayForModel("AlternateTemplateName", "htmlFieldName", new { id = "some value" }))


###Results

Results, again, depend on the template you design for them unless you're using one of the built in templates provided by MVC

<a href='http://buildstarted.com/2010/09/10/overriding-displayfor-and-editorfor-to-create-custom-outputs-for-mvc/'>More Detail</a> about custom templates in my previous post.

##DisplayText

DisplayText outputs the property name of a particular property.

###Usage

    @Html.DisplayText("Title")

###Results

This particular call will output the title of the page.

##DisplayTextFor

DisplayTextFor will output the title of a model property. This particular method will also look at any DataAnnotations you have applied to a property such as "Display" or "DisplayName"

###Usage

    public class SomeModel {
        [DisplayName("First name")]
        [Display("First name")]
        public string FirstName { get; set; }
    }

    @Html.DisplayTextFor(model => model.FirstName)


###Results

This will output "First name" (without quotes) using the data annotations. Otherwise it would output "FirstName" as it is the name of the property.

This can further be modified by overriding the ModelmetaData.

##Editor

This method returns and html input element representation of an object value.

###Usage

    @Html.Editor("ModelObject")
    @Html.Display("ModelObject", new { Value="Test" })


##EditorFor

Renders objects as input elements. This is overridable by providing your own templates.

###Usage

    @Html.EditorFor(model => model)
    @Html.EditorFor(model => model.property)
    @Html.EditorFor(model => model.property, new { id = "some value" })
    @Html.EditorFor(model => model.property, "AlternateTemplateName")
    @Html.EditorFor(model => model.property, "AlternateTemplateName", new { id = "some value" })
    @Html.EditorFor(model => model.property, "AlternateTemplateName", "htmlFieldName")
    @Html.EditorFor(model => model.property, "AlternateTemplateName", "htmlFieldName", new { id = "some value" })


###Results

Results depend on the templates for the particular model you've passed in. "AlternateTemplateName" is a template you create for your particular model. HtmlFieldName is for when you are using a template for a single field you can specify an alternate name.

<a href='http://buildstarted.com/2010/09/10/overriding-displayfor-and-editorfor-to-create-custom-outputs-for-mvc/'>More Detail</a> about custom templates in my previous post.

##EditorForModel

Same as EditorFor but focuses on the model itself and does not accept any parameters for individual elements for a model.

###Usage

    @Html.EditorForModel()
    @Html.EditorForModel(new { id = "some value" })
    @Html.EditorForModel("AlternateTemplateName", new { id = "some value" })
    @Html.EditorForModel("AlternateTemplateName", "htmlFieldName")
    @Html.EditorForModel("AlternateTemplateName", "htmlFieldName", new { id = "some value" }))


###Results

Results, again, depend on the template you design for them unless you're using one of the built in templates provided by MVC

<a href='http://buildstarted.com/2010/09/10/overriding-displayfor-and-editorfor-to-create-custom-outputs-for-mvc/'>More Detail</a> about custom templates in my previous post.