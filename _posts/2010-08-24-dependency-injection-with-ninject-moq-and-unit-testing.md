---
layout: post
title: Dependency Injection with Ninject, Moq and unit testing
---

##An Existing DataContext Dependency

    public class DataContext : DbContext {
        public DbSet<User> Users {get;set;}
    
        public override int SaveChanges() {}
    }

    public class UserController : Controller {
    
        public ActionResult List() {
            DataContext data = new DataContext();
            var users = data.Users;
    
            return View(users);
        }
    }


Here we have a pretty standard UserController that shows a list of users when we navigate to <strong>/User/List</strong>.
However, we're very tightly coupled to our DataContext() that we've defined. This requires our unit testing to utilize the same datacontext. So what we're going to do is extract an interface from our DataContext class and we'll call it <strong>IDataContext</strong>.

    public interface IDataContext {
        IDbSet<User> Users { get; set; }
        int SaveChanges();
    }


We now implement the Interface in our DataContext, which should be done automatically if you use the built in Visual Studio 2010 <strong>Extract Interface</strong>.

<img src="http://aws.buildstarted.com/extractinterface.png" alt="Extract Interface" title="" />

Now we rewrite our UserController to something similar to the following

    public class UserController : Controller {
        IDataContext dataContext;
    
        public ActionResult List() {
            return View(dataContext.Users);
        }
    }


However, we need to setup the dataContext. One of the ways we could do that is to use a couple of constructors like the following:

    public class userController : Controller {
    
        IDataContext dataContext;
    
        //default constructor used by mvc
        public userController() : this(new DataContext()) {}
    
        //constructor we'll use for our tests...
        public userController(Data.IDataContext dataContext) {
            this.dataContext = dataContext;
        }
    }


##Ninject comes to save the day!

The trouble with the above is that we're still tightly bound to the <strong>DataContext</strong> in our default constructor for MVC. We could use <a href='http://ninject.org/' target='&#95;new'>Ninject</a> here with the new MvcServiceLocator that's part of MVC3. In doing so we can remove the default constructor and always pass in the data context we use. In our Global.asax file we're going to setup our ServiceLocator using Ninject in the Application&#95;Start method.

    public class RegistrationModule : NinjectModule {
    
        public override void Load() {
            Bind<IDataContext>().To<DataContext>().InRequestScope();
        }
    }


    var kernel = new StandardKernel(new RegistrationModule());
    var locator = new Library.ServiceLocator(kernel);
    MvcServiceLocator.SetCurrent(locator);


What we're doing is binding any time you create an IDataContext to use a specific object, such as our DataContext. The <strong>InRequestScope()</strong> creates an instance <strong>per web request</strong> and will no longer exist when the request is over. Other scopes are <strong>InTransientScope</strong> (create a new instance on each time one is needed), <strong>InSingletonScope</strong> (create a single instance and return that instance anytime it's requested), and <strong>InThreadScope</strong> (create an instance per thread). Now, whenever our controller is activated via MVC it will automaticagically use the Ninject binding to create the required DataContext.

Now our UserController should look something like this. Notice I've removed the parameterless constructor and all references to the old DataContext have now been updated to reference the IDataContext defined in the controller.

    public class userController : Controller {
    
        IDataContext dataContext;
    
        //constructor we'll use for our tests...
        public userController(Data.IDataContext dataContext) {
            this.dataContext = dataContext;
        }

        public ActionResult List() {
            return View(this.dataContext.Users);
        }
    }


##Unit Testing

Now that we have dependency injection in place we can Unit test our controller. By default I want the UserController's Index action to return a list of users. We're going to use <a href='http://code.google.com/p/moq/' target='&#95;new'>Moq</a> for our Mocking.

    public void IndexReturnsListOfUser() {
        var dc = new Mock<IDataContext>();
        var users = new Mock<IDbSet<User>>();
    
        dc.SetupGet(d => d.Users).Returns(users.Object);
    
        userController controller = new userController(dc.Object);
    
        ViewResult result = controller.Index(null) as ViewResult;
            
        Assert.IsInstanceOfType(result.ViewData.Model, typeof(IEnumerable<User>));
    }


We've created a Mock based on our newly Interfaced IDataContext, initialized our userController passing in our mocked DataContext - which doesn't use Ninject in this context.

##Final

With a little bit of work we can use Dependency Injection to separate our coupled classes and allow for stuff like Unit Testing (properly) as well as possibly different data layers, business layers and interfaces. I'm sure you'll see all sorts of possibilities once you start to get used to writing code in this manner.

###- Ben

###Update:

Added controller final code to make it clearer.