---
layout: post
title: Modelbinderproviders automatic binding your models is easy as pie
---

One of the things I really like about MVC is it's ability to know things. You don't have to tell it anything, it just <strong>knows</strong>. How does it do this? How can MVC automagically know that a request for <strong>/home/index</strong> should go to the <strong>HomeController.Index</strong>? It's magic. No, really, it's magic!

Darn, thought I had you there. MVC uses a <a href='http://en.wikipedia.org/wiki/Convention_over_configuration'>Convention over configuration</a> software design paradigm. This basically means we don't have to configure everything if we follow a certain pattern. This allows us to imply certain behaviors based on the construction of our code rather than implicitly writing it.

One of the things I noticed when playing with MVC was that I found myself always writing ModelBinders. I wrote a <a href='http://buildstarted.com/2010/09/12/custom-model-binders-in-mvc-3-with-imodelbinder/'>previous article</a> on the subject. But suffice to say I always had to make sure I added the new ModelBinder that I wrote to the Binders list in <strong>ModelBinders.Binders.Add()</strong>. I didn't care for this so I wrote a <strong>ModelBinderProvider</strong> that will automagically look for my model binders whenever I needed them.

##Design

First, I needed some sort of design pattern that would make it easy for my ModelBinder to find my custom bindings. I settled on a <strong>&lt;Model&gt;ModelBinder</strong> naming convention. Here's a quick sample.

    public class User {
        public string Name {get;set;}
    }

    public class UserModelBinder : IModelBinder {
        //implement binder
    }


This UserModelBinder will now be automagically bound to my User class by way of convention over configuration. There's no need for me to tell the ModelBinder that model A maps to binder B. It's implied. But, we also need a way to override these bindings whenever necessary because not everything will be perfect so I have to add that, as well.

The following is the start of our class. I'm just defining a static Dictionary to keep track of found ModelBinders.

    public class AutoModelBinder : IModelBinderProvider {

        /// <summary>
        /// Cached collection of existing binders
        /// </summary>
        static Dictionary<Type, IModelBinder> Binders { get; set; }

        /// <summary>
        /// Static constructor to initialize Binders
        /// </summary>
        static AutoModelBinder() {
            Binders = new Dictionary<Type, IModelBinder>();
        }
    }


If, for some ungodly reason, we want to manually bind a model, we can. This is a very important concept in Convention over Configuration. We provide defaults but allow it to be overridden.

    /// <summary>
    /// Manually register ModelBinders for some strange reason
    /// </summary>
    /// <param name="type">The type of object we're binding to</param>
    /// <param name="instance">The instance of our Model Binder</param>
    public static void RegisterType(Type type, IModelBinder instance) {
        if (Binders.ContainsKey(type))
            Binders[type] = instance;
        else
            Binders.Add(type, instance);
    }


Now for the meat of the class. We're implementing <strong>IModelBinderProvider</strong>, which gives us one method called <strong>GetBinder</strong>. This will be called whenever MVC would like to bind a model for our request. First, we need to check to see if we've already created an instance of our model binder for the requested type. If one isn't found we then look in the current assembly and find one. There really isn't much magic here I'm sorry to say.

    /// <summary>
    /// Interface for IModelBinderProvider.GetBinder.
    /// Checks Binders for the passed type else loop through the assembly and look for a binder
    /// </summary>
    /// <param name="modelType">The type of object we're going to bind to</param>
    /// <returns>An instance of IModelBinder from our list of found Binders.</returns>
    public IModelBinder GetBinder(Type modelType) {
        //Check to see if a type was already bound.
        if (Binders.ContainsKey(modelType)) 
            return Binders[modelType];

        //Check the assembly and look for a <name>ModelBinder
        Assembly assembly = Assembly.GetExecutingAssembly();
        Type[] types = assembly.GetTypes();
        foreach (Type type in types) {
            //Convention over configuration
            if (type.Name == modelType.Name + "ModelBinder") {
                IModelBinder instance = (IModelBinder)assembly.CreateInstance(type.FullName);
                Binders.Add(modelType, instance);
                return instance;
            }
        }

        return null;
    }


Download Project: <a href='http://buildstarted.com/wp-content/uploads/2010/12/ModelBinderProviderTest.zip'>ModelBinderProviderTest.zip</a>