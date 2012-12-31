---
layout: post
title: Getting anonymous types to cross the appdomain boundary
---

Matthew Abbott asked <a href='http://stackoverflow.com/q/6452034/365526'>this</a> question on <a href='http://stackoverflow.com/'>StackOverflow.com</a> and it's an interesting challenge that I wanted to solve. The question basically wanted to know how to pass an Anonymous type from one AppDomain to another.

I've had such little experience with AppDomains. This was definitely going to be a challenge for me.

The first thing I did was find out what error would occur when I attempted to use an <strong>Anonymous Type</strong> and here's the result.

<div style='text-align:center;'><a href="http://aws.buildstarted.com/proxywithanonymoustype.png"><img src="http://aws.buildstarted.com/proxywithanonymoustype.png" alt="" title="proxywithanonymoustype" width="634" height="309" class="alignnone size-full wp-image-599" /></a></div>

As you can see, anonymous types are not Serializable. This leads me to believe that I need to make the anonymous type serialized and if I could do that then all will be well.

I've created a ProxyAnonymousObject that will wrap the anonymous object in an <strong>ISerializable</strong> wrapper. ISerializable has a single implementation, <strong>GetObjectData</strong> and a constructor override.

When the <strong>GetObjectData</strong> method is called we're going to add a value which contains the anonymous model's FullName. This will allow us to cache type conversions for overall speed increases. We're also going to iterate through all the Anonymous Type's properties and add them to the serializationInfo object like so:

    public void GetObjectData(SerializationInfo info, StreamingContext context) {

        //I wonder if it's safe to assume that this will always be the first property
        info.AddValue("ProxyAnonymousObject_ModelType", modelType);

        foreach (var pi in Model.GetType().GetProperties()) {
            info.AddValue(pi.Name, pi.GetValue(Model, null), pi.PropertyType);
        }

    }


This basically copies our anonymous type property by property into a serialized state. I don't know enough about serialization to wonder if this works with all types. It seemed to work fine with all the generic types I've tried. Now that we have an <strong>ISerializable</strong> object we can now pass it into our function. Since I know the target type has a few methods such as <strong>SetModel</strong> and <strong>Render</strong>.

Here is the object we're executing in a different <strong>AppDomain</strong>

    public class DynamicCallTest {
        public dynamic Model { get; private set; }

        public void SetModel(dynamic model) {
            this.Model = model;
        }

        public void Render() {
            Console.WriteLine(Model.Name);
        }
    }


Here is what we're using to call that object

    public void ExecuteSomethingWithDynamicModel(ProxyAnonymousObject model) {

        System.Console.WriteLine("Executing from {0}", AppDomain.CurrentDomain.FriendlyName);
        if (DomainLibrary == null)
            DomainLibrary = Assembly.Load(System.IO.File.ReadAllBytes("DomainLibrary.dll"));

        type = DomainLibrary.GetType("DomainLibrary.DynamicCallTest");
        instance = Activator.CreateInstance(type);
        var setModel = type.GetMethod("SetModel", BindingFlags.Public | BindingFlags.Instance);
        var render = type.GetMethod("Render", BindingFlags.Public | BindingFlags.Instance);

        setModel.Invoke(instance, new object[] { new ProxyDynamicObject() { Proxy = model } });
        render.Invoke(instance, null);
    }


We're again wrapping our <strong>ProxyAnonymousObject</strong> in a <strong>ProxyDynamicObject</strong> so that we can use <strong>dynamic</strong> in our called class. Since we're using an anonymous type our called class doesn't know anything about what we're passing so we need to use dynamic. In the <strong>ProxyDynamicObject</strong> we're going to override <strong>TryGetMember</strong> and use a dictionary to get our values.

Now here's where the neat stuff comes...we still need a concrete type in our new appdomain that represents the anonymous object we passed in. So originally I opted to create a type on the fly and use reflection. However, for the simplistic nature of this I've opted for a <strong>IDictionary</strong> instead. (I'll have to add recursion later to take care of nested properties)

When the type is deserialized across the AppDomain threshold a constructor for the <strong>ProxyAnonymousObject</strong> is called

    public ProxyAnonymousObject(SerializationInfo info, StreamingContext ctx) {
        try {

            string fieldName = string.Empty;
            object fieldValue = null;

            foreach (var field in info) {
                fieldName = field.Name;
                fieldValue = field.Value;

                if (string.IsNullOrWhiteSpace(fieldName))
                    continue;

                if (fieldValue == null)
                    continue;

                ModelProperties.Add(fieldName, fieldValue);

            }

        } catch (Exception e) {
            var x = e;
        }
    }


All we're doing here is reading the <strong>SerializationInfo</strong> from the passed parameter and adding the values to a Dictionary object. Then in the <strong>TryGetMember</strong> of ProxyDomainObject we just return the value from the Dictionary.

In the words of the immutable Jon Skeet: "<strong>Anonymous type are meant to be used for simple projections of very loosely coupled data, used only within a method.</strong>"

So really, you shouldn't use this for anything. It was just a test. It's slow. It's very buggy. It probably doesn't work everywhere. But it does work here. 

###Ben Dornis