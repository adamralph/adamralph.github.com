---
layout: post
title: Custom model binders in mvc 3 with imodelbinder
---

####Update: Apparently this works in MVC 1 and 2 - Thanks, Mike!

One of the things you'll find yourself doing quite often is loading an object from a database or other source given an id from a url. Something along the lines of <strong>http://localhost/users/details/john</strong> and then loading the User model with the username of "john".

    public ActionResult Details(string username) {
        var user = db.Users.Single(u => u.Username == username);

        return View(user);
    }


There's nothing really wrong with this. It just leads to a lot of code repetition as you'll probably have something similar  for and Edit method, Edit with HttpPost and possibly several other actions. Wouldn't it be great if you could just automagically load the User without having to call this code?

##Implementing IModelBinder

It turns out you can. We're going to implement IModelBinder to turn that lowly string into a full fledge User model before you even get to your action. We start by creating a new ModelBinder for our user. This example is assuming you're using the default Route of <strong>{controller}/{action}/{id}</strong>

    public class UserModelBinder : IModelBinder {

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext) {
            ValueProviderResult value = bindingContext.ValueProvider.GetValue("id");

            User user = db.Users.SingleOrDefault(u => u.Username == value.AttemptedValue);

            return user;
        }
    }


The first line of code in the <strong>BindModel</strong> method just grabs the id from the Request. In this case it's called "id" since we're using the Default Route to map to this action. Another way to bind it would be to use the <strong>bindingContext.ModelName</strong> instead of just <em>id</em>.

The second line uses the value.AttemptedValue and makes a call to our Users list to find the one that matches the value passed in. A better approach to this would be to use IoC to pass in our Repository.

Our Action method in our controller would change from the above to the following

    public ActionResult Details(User user) {
        return View(user);
    }


MVC will then look for an Action that matches our action name in our route. It finds the Details(User user) method. It then looks for a model binder for the parameters of the Details action, in this case User. It won't find any however because we need to tell MVC about our model binder mapping. To do that we put a line of code in the Application&#95;Start() of our global.asax

    ModelBinders.Binders.Add(typeof(User), new UserModelBinder());

This tells MVC anytime we have a typeof(User) as a parameter in an action. We should use the UserModelBinder to try and create an object to fill the User.

Doing this allows us to save on repetitive code and makes our controllers cleaner. One downside I see to this is if someone new to MVC comes along they'll just think it's magic that you've loaded the right user that's being passed into the Action. However that shouldn't stop you from doing this. Cleaner code is happier code! :)

###IoC (Inversion of Control) and Model Binders

Those that are wondering how to implement IoC to load the repository in your model binders. Here's how I've currently implemented it using Ninject.

In my <a href='http://buildstarted.com/2010/08/24/dependency-injection-with-ninject-moq-and-unit-testing/'>Ninject</a> setup I added the following binding and changed my ModelBinder to use it.

    Bind<IDataContext>().To<DataContext>().InRequestScope();

    public class UserModelBinder : IModelBinder {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext) {
            ValueProviderResult value = bindingContext.ValueProvider.GetValue("id");

            IDataContext db = (IDataContext)MvcServiceLocator.Current.GetService(typeof(IDataContext));

            User user = db.Users.SingleOrDefault(u => u.Username == value.AttemptedValue);

            return user;
        }
    }


##Binding to cookies

Another use of model binding is to map cookies directly to objects as well. This is more useful for complex cookies with key/value pairs.

    public class ValuePairCookie {
        public string Name { get; set; }
        public string Location { get; set; }
    }

    public class ValuePairCookie ModelBinder : IModelBinder {

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext) {
            HttpCookie c = controllerContext.HttpContext.Request.Cookies["somecookie"]

            ValuePairCookie value = new ValuePairCookie () {
                foo.Name = c.Values["Name"],
                foo.Location = c.Values["Location "]
            }

            return value
        }
    }


This will bind as long as you have the parameter type in any of your action methods. It's a great way to shortcut access to form values.

I hope this helps someone out there.

###- Ben