---
layout: post
title: Creating your own modelmetadataprovider to handle custom attributes
---

I've answered a couple questions recently about using the DescriptionAttribute from the System.ComponentModel namespace, as well as creating your own Attributes and using them in HtmlHelpers. I've answered each one individually to answer the specific questions with very specific answers to each one. But it got me thinking that MVC has a way to override just about everything and doubtless the MetadataProvider was one of them. A quick search of the code available at <a href='http://aspnet.codeplex.com/'>codeplex</a> lead me to the <strong>ModelMetadataProviders</strong>.

I'm going to create a new class based on the <strong>DataAnnotationsModelMetadataProvider</strong> since I use this particular provider a lot.

    public class CustomModelMetadataProvider : DataAnnotationsModelMetadataProvider {
        protected override ModelMetadata CreateMetadata(
                                 IEnumerable<Attribute> attributes,
                                 Type containerType,
                                 Func<object> modelAccessor,
                                 Type modelType,
                                 string propertyName) {

            var data = base.CreateMetadata(
                                 attributes, 
                                 containerType, 
                                 modelAccessor, 
                                 modelType, 
                                 propertyName);
    
            return data;
        }
    }

	
Simple and to the point. Now how do we access the System.ComponentModel.DescriptionAttribute. Well, luckily for us, the attributes parameter of CreateMetadata provides us with all the attributes assigned to our particular property we're attempting to get data for. Since attributes is IEnumerable we can use linq to find a particular attribute.

    protected override ModelMetadata CreateMetadata(
                                 IEnumerable<Attribute> attributes,
                                 Type containerType,
                                 Func<object> modelAccessor,
                                 Type modelType,
                                 string propertyName) {
        var data = base.CreateMetadata(attributes,
                                 containerType,
                                 modelAccessor,
                                 modelType,
                                 propertyName);

        var description = attributes
                    .SingleOrDefault(a => typeof(DescriptionAttribute) == a.GetType());
        if (description != null) data
                    .Description = ((DescriptionAttribute)description).Description;

        return data;
    }

	
This is great. This will take care of old code that relies on the old DescriptionAttribute rather than the new DataAnnotations DisplayAttribute(Description=""). What if we wanted to add our own custom information to the ModelMetadata? Well the MVC team has graciously provided us with an <strong>AdditionalValues</strong> property to the ModelMetadata. In this example I'm going to make a tooltip attribute for the title attribute of an html element.

    protected override ModelMetadata CreateMetadata(
                                 IEnumerable<Attribute> attributes, 
                                 Type containerType, 
                                 Func<object> modelAccessor, 
                                 Type modelType, 
                                 string propertyName) {
        var data = base.CreateMetadata(attributes,
                                  containerType, 
                                 modelAccessor, 
                                 modelType, 
                                 propertyName);

        var tooltip = attributes
                    .SingleOrDefault(a => typeof(TooltipAttribute) == a.GetType());
        if (tooltip != null) data.AdditionalValues
                    .Add("Tooltip", ((TooltipAttribute)tooltip).Tooltip);

        return data;
    }

	
Same as before but instead of using an existing property of the ModelMetadata we're adding a key/value pair to the AdditionalValues property.

##Using our new-found powers for awesome

So how do we use this new found ability? First we're going to set the current provider to our new provider by adding this to our global.asax Application&#95;Start() method.

    ModelMetadataProviders.Current = new CustomModelMetadataProvider();

	
And now we're going to use a new HtmlHelper called ToolTipFor. 

    public static IHtmlString TooltipFor<TModel, TValue>(
                                 this HtmlHelper<TModel> html, 
                                 Expression<Func<TModel, TValue>> expression) {
        var x = ModelMetadata.FromLambdaExpression<TModel, TValue>(expression, html.ViewData);
        if (x.AdditionalValues.ContainsKey("Tooltip"))
            return new HtmlString((string)x.AdditionalValues["Tooltip"]);

        return new HtmlString("");
    }

	
ModelMetadata.FromLambdaExpression uses our new model provider to fill out the values and we then we check for our tooltip property. If it's found we return, else we return an empty string.

In our View we're going to utilize our new HtmlHelper like so:

    public class User {
        [Tooltip("Please enter your name.")]
        public string Name { get; set; }
    }


    @Html.TextBoxFor(m => m.Name, new { title=@Html.TooltipFor(m => m.Name)} )

And voila! We have a tooltip for our text input box. There are probably many more additions that can be made, such as overriding localizations. I hope this gives you a good start in how extensible MVC is.

###- Ben