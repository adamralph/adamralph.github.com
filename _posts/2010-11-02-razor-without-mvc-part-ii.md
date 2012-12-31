---
layout: post
title: Razor without mvc part ii
---

After the wonderful blog post by Matt at <a href='http://www.fidelitydesign.net/'>http://www.fidelitydesign.net/</a> (which is based on my previous post <a href='http://buildstarted.com/2010/09/29/razor-view-engine-without-mvc-at-all/'>here</a>.) I looked into adding anonymous types to the compiler. Rather than start with my version of the compiler I've used his version. It was written much better than my thrown together example. (You can download the original <a href='http://www.fidelitydesign.net/?p=208'>here</a>.)

###Original code

To call the razor parser is simple. We create our template as a string, create our model (if necessary) and call Razor.Parse.

    string template = "Hello @Model.Name!";
    User user = new User { Name = "Matt" };

    result = Razor.Parse(template, user, "test");


What I'd like to be able to do, however, is make a call like 

    result = Razor.Parse(template, new { Name = "Ben" });

Due to limitations in c# it doesn't just work that way. We'll need to modify our classes.

###ITemplate

First we need to create a new interface template. We're going to use the ITemplate interface Matt created is his version of the project to create a new ITemplateDynamic.

    public interface ITemplateDynamic : ITemplate {
        dynamic Model { get; set; }
    }


Here we're defining a new ITemplateDynamic with a dynamic model instead of a generic model. We need to then create a class that inherits from TemplateBase and implements our new interface. 

    public abstract class TemplateBaseDynamic : TemplateBase, ITemplateDynamic {

        dynamic model;

        public dynamic Model {
            get { return model; }
            set { model = new RazorDynamicObject() { Model = value }; }
        }

        class RazorDynamicObject : DynamicObject {
            internal object Model { get; set; }

            public override bool TryGetMember(GetMemberBinder binder, out object result) {
                result = Model.GetType().InvokeMember(binder.Name,
                    System.Reflection.BindingFlags.GetProperty | 
                        System.Reflection.BindingFlags.Instance | 
                        System.Reflection.BindingFlags.Public | 
                        System.Reflection.BindingFlags.NonPublic,
                    null,
                    Model,
                    null);

                return true;
            }
        }

    }


Using the DynamicObject type in a similar method as I did in a <a href='http://buildstarted.com/2010/08/23/fun-with-dynamicobject-dynamic-and-the-settings-table/'>previous post</a> we can override the actual anonymous type model with this and, using reflection, return appropriate values per call.

###Compiling

Next we'll need to modify the Compile method in RazorCompiler.cs. We need to determine the new basetype from our model. This gets a bit difficult as there's no .IsAnonymousType method to call.

The original method to determine type was simple

    Type baseType = (modelType == null)
        ? typeof(TemplateBase)
        : typeof(TemplateBase<>).MakeGenericType(modelType);


However we now need to test for 3 different types: null, generic and anonymous. The following, with the help of the wonderful Jon Skeet, is the simplest way I've come up with.

    bool anonymousType = 
        (modelType.IsClass && 
         modelType.IsSealed && 
         modelType.BaseType == typeof(object) && 
         modelType.Name.StartsWith("<>") && 
         modelType.GetCustomAttributes(
             typeof(CompilerGeneratedAttribute), true) != null;


With this information we can just to a nested conditional operator

    Type baseType = (modelType == null)
        ? typeof(TemplateBase)
        : (anonymousType
            ? typeof(TemplateBaseDynamic)
            : typeof(TemplateBase<>).MakeGenericType(modelType));


Awesome. Now we inherit from the proper base type for our different model types.

Now that we're in the home stretch, one last change to make.

After we get the new template object in our Parse method in Razor.cs we then need to assign the model to the new ITemplateDynamic.

    if (instance is ITemplate<T>)
        ((ITemplate<T>)instance).Model = model;
    else if (instance is ITemplateDynamic)
        ((ITemplateDynamic)instance).Model = model;


###And now we're done.

To call the Razor.Parse with the new anonymous type is simple.

    string template = "Hello @Model.Name!";

    result = Razor.Parse(template, new { Name = "Matt" }, "test");


I don't think it can get any easier. Thanks Matt from fidelitydesign for taking my code and making it more awesome than anything I could have done. Please visit his <a href='http://www.fidelitydesign.net/'>blog</a>.

Download the code for today's post: <a href='http://buildstarted.com/wp-content/uploads/2010/11/Razor.zip'>Razor Compiler</a>

###-Ben