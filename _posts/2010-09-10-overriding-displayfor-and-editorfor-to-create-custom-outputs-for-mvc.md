---
layout: post
title: Overriding displayfor and editorfor to create custom outputs for mvc
---

At the <a href='http://www.webcamps.ms'>Webcamp</a> in Los Angeles, <a href='http://www.haacked.com'>Phil Haack</a> showed off a feature that I wasn't presently aware of and I thought I'd share it with you. I've created a sample model that will be used to show off both a Display Template and Editor Template. You'll notice I added a UIHint to the EmailAddress property. By default the DisplayFor would use the property type, in this case a string, however we want to override that and there are two ways to do it. One is to add a DataType attribute and the other is a UIHint. UIHint overrides the other attributes.

    public class User {
        public string Username { get; set; }

        //[UIHint("EmailAddress")]
        [DataType(DataType.EmailAddress)]
        public string EmailAddress { get; set; }

        public DateTime DOB { get; set; }
    }


Now that we have our simple object let's create a Display Template for the EmailAddress property.

##Display Templates

Display templates are cshtml partials that have the same name as the type they're going to override the default templates provided by MVC. To create a Display Template you just create a Folder named "DisplayTemplates" within one of your controller views (or the shared folder) like so:

<img src="http://aws.buildstarted.com/displaytemplatesfolders.png" alt="Display Template Folder Structure" title="Display Templates Folder Structure" />

I've created an EmailAddress.cshtml template that will format an email address with a mailto: link

    @inherits System.Web.Mvc.WebViewPage<string>
    <a href='mailto:@Model'>@Html.DisplayTextFor(m => m)</a>


I used both methods, @Model and an Html helper to display the actual value of the model. The call is easy enough in code. By default, when you create a Detail strongly typed view it outputs @Model.PropertyName. In this case we want to use the DisplayFor html helper.

    <fieldset>
        <legend>Fields</legend>

        <div class="display-label">Username</div>
        <div class="display-field">@Model.Username</div>

        <div class="display-label">EmailAddress</div>
        <div class="display-field">@Html.DisplayFor( m => m.EmailAddress)</div>
    </fieldset>


<img src="http://aws.buildstarted.com/displaytemplatemailtoemail.png" alt="Display For Email Address Link" title="Display For Email Address Link" />

Easy enough. We can modify the templates to our hearts content. 

##Editor Templates

Editor Templates are the same as display templates. To create an Editor Template you just create a folder named "EditorTemplates" within one of your controller views (or the shared folder) like so:

<img src="http://aws.buildstarted.com/editortemplatefolders.png" alt="Editor Templates Folder Example" title="Editor Templates Folder Example" />

In this case I've created a DateTime editor to show you a sample of the power of editor templates. I've imported the jquery ui library to add a datepicker to our editor.

    @inherits System.Web.Mvc.WebViewPage<System.DateTime>
    @Html.TextBox("", (Model.ToShortDateString()), new { @class = "datePicker" })


the @class is the html attribute we're using to assign the datePicker to textbox. Below is the jquery to add the datepicker to our new Textbox with the added class attribute.

    <script type='text/javascript'>
        $(document).ready(function() {
            $(".datePicker").datepicker({buttonImage: "/content/images/calendar.gif", showOn: "both"});
        });
    </script>

And here are the results

<img src="http://aws.buildstarted.com/editortemplatedatetimeeditor.png" alt="Editor DateTime Sample" title="Editor DateTime Template Example" />

##Conclusion

MVC has really gone to great lengths to allow you to override all kinds of built in methods.

###- Ben