---
layout: post
title: Breaking changes in xBehave.net 0.11.0
location: Zurich
tags:
- .net 
- xbehave.net
---
Today sees the release of [xBehave.net](https://bitbucket.org/adamralph/xbehave.net) version [0.11.0](https://nuget.org/packages/Xbehave/0.11.0).

Unfortunately, 0.11.0 contains breaking changes to the API. It was a difficult decision but, after a week or two of agonizing, I decided to jump over the cliff to avoid the tiger*.

##Teh Original Codez

In 0.10.0, a step definition method had 4 overloads...

	Given(Action body)                            // 1
	Given(Func<IDisposable> body)                 // 2
	Given(Func<IEnumerable<IDisposable>> body)    // 3
	Given(Action body, Action dispose)            // 4

<a name="more"></a>
    
(The same overloads were also available for `When()`, `Then()`, `And()` and `But()` although the use of When(), Then() and But() rarely required anything other than overload 1.)

<!--excerpt-->

Overload 1 is the most straightforward and, when working with non-`IDisposable` objects and in a context requiring no explicit teardown, it is all that is needed.

Overloads 2 and 3 were added in order to ensure disposal of `IDisposable` objects...

	Given(() => foo = new SomeDisposable())       // 2
	Given(() => new[]                             // 3
	    {
	        foo = new SomeDisposable(),
	        bar = new SomeDisposable(),
	    })

Upon execution of a step defined using either of these overloads, the returned `IDisposable` objects are registered for disposal. The disposals are executed in a seperate test command which is guaranteed to execute at the end of the scenario, even if exceptions are thrown during execution of the scenario. The intention was to achieve a similar effect as a `using` block. (I'll come to overload 4 shortly.)

##The API Design Fail

Unfortunately, overloads 2 and 3 were a mistake. Here's why...

	Given(() =>           // 2	
    {
        foo = new SomeDisposable();
        foo.Bar();        // which, of course, may throw an exception
        return foo;
    });

As you've already spotted, this does not ensure disposal of `foo`. If `foo.Bar()` throws an exception, `foo` will not be returned from the method and will not be registered for disposal and, therefore, will not be disposed. The same applies to overload 3...

	Given(() =>           // 3
	    {
	        foo = new SomeDisposable();
	        foo.Bar();    // which, of course, may throw an exception
	        baz = new SomeDisposable();
	        baz.Bar();    // which, of course, may throw an exception
	        return new[] { foo, baz };
	    });

##Shiny New Things

To solve this problem, we need to register `IDisposable` objects immediately after they are created. In 0.11.0, the new `Using()` extension method for `IDisposable` provides this. Here's how you use it...

	Given(() =>           // 1
	    {
	        foo = new SomeDisposable().Using();
	        foo.Bar();    // which, of course, may throw an exception
	    });
	Given(() =>           // 1
	    {
	        foo = new SomeDisposable().Using();
	        foo.Bar();    // which, of course, may throw an exception
	        baz = new SomeDisposable().Using();
	        baz.Bar();    // which, of course, may throw an exception
	    });

Now, it doesn't matter what happens after the call to `Using()`. The object will be disposed at the end of the scenario. This is much closer to the effect achieved with a `using` block. Of course, if `Using()` throws an exception then we still have the same problem, but this would have to be something like `OutOfMemoryException` so non-disposal of `foo` or `baz` will probably be the least of your worries!

##The Really Tricky Part

OK, this is going to get a little ugly. I can't just deprecate overloads 2 and 3 with `[Obsolete]` because arguments to these methods can be defined as lambda expressions like so...

    Given(() => foo = new SomeDisposable())                      // 2

Here, the compiler will pick overload 2 since `SomeDisposable` implements `IDisposable` (or overload 3 if `SomeDisposable` is some bizarre animal that implements `IEnumerable<IDisposable>`). If I deprecate overload 2 using `[Obsolete]`, the compiler will generate a warning for the above line of code. In that case, how do I change it to use overloads 1 or 4? Like so...

    Given((Action)(() => foo = new SomeDisposable().Using()))    // 1

or

	Given(                                                       // 4
	    () => foo = new SomeDisposable(),
	    () =>
	    {
	        if (foo != null)
	        {
	            foo.Dispose();
	        }
	    })
	
This is ridiculous. No-one wants to write this code. For this reason I have removed, rather than deprecated, overloads 2 and 3. With overloads 2 and 3 removed, I'm now using overload 1 without having made any code change...

    Given(() => foo = new SomeDisposable())                      // 1

Even though the expression returns an object, the compiler knows it can ignore this and chooses overload 1. The big problem now is, because there is no registration of the object, it will not be disposed. This was the source of all my agonizing. If the change caused compilation errors, developers would be forced to revisit, and fix, the call sites. However, in this case, the code will still compile and execute but the returned object will no longer be disposed. In order to fix this, we need to add a call to `Using()`...

    Given(() => foo = new SomeDisposable().Using())              // 1

This is a very simple change but it could mean revisiting a lot of code. **When upgrading from 0.10.0 to 0.11.0, all step definitions using overloads 2 or 3 need to be revisited and a call to `Using()` needs to be added**. Please accept my sincerest apologies. I'm just glad that I caught this during initial development rather than in the post 1.0.0 era...

##And Whilst We're At It...

Overload 4 was introduced to allow execution of teardown which is not encapsulated in an `IDisposable` object...

	Given(() =>    // 4
	    {
	        foo = new SomeContext();
	        foo.Setup();
	    },
	    () => foo.Teardown())

Similarly to disposal, the teardown is guaranteed to execute at the end of the scenario. This overload was actually OK but, whilst scrutinizing this part of the API, I realised that the intent could be more clearly communicated with a fluent method...

	Given(() =>    // 1
	    {
	        foo = new SomeContext();
	        foo.Setup();
	    }).Teardown(() => foo.Teardown())

In this example, the name of `foo.Teardown()` already clearly communicates the intent but imagine using some exotic API where the name is `foo.Wibble()`.

Fortunately it was possible to deprecate, rather than remove, overload 4 since it is differentiated from the other overloads by an extra parameter and, therefore, does not suffer from the same problems as overloads 2 and 3 described in The Really Tricky Part.

*Michael Feathers (2004). Working Effectively with Legacy Code. USA: Prentice Hall PTR. p5.