---
layout: post
title: New Background Attribute in xBehave.net 0.12.0
location: Zurich
tags:
- .net
- xbehave.net
---
With the release of [xBehave.net](https://github.com/xbehave/xbehave.net) version [0.12.0](https://nuget.org/packages/Xbehave/0.12.0), it is now possible to add background steps to features using the new [Background] attribute. E.g.

<a name="more"></a>

    [Background]
	public static void Background()
	{
	    "Given a customer named \"Dr. Bill\""
	        .Given(() => Users.Save(new Customer
	            { Name = "Dr. Bill", Password = "oranges" }))
	        .Teardown(() => Users.Remove("Dr. Bill"));
	
	    "And a blog named \"Expensive Therapy\" owned by \"Dr. Bill\""
	        .And(() => Blogs.Save(new Blog
	            { Name = "Expensive Therapy",
	                Owner = Users.Get("Dr. Bill") }))
	        .Teardown(() => Blogs.Remove("Expensive Therapy"));
	}

<!--excerpt-->

Where a typical scenario may look something like:-

	[Scenario]
	public static void DoctorBillPostsToHisOwnBlog()
	{
	    "Given I am logged in as Dr. Bill"
	        .Given(() => Site.Login("Dr. Bill", "oranges"));
	
	    "When I try to post to \"Expensive Therapy\""
	        .When(() => Blogs.Get("Expensive Therapy")
	            .Post(new Article { Body = "This is a great blog!" }));
	
	    "Then I should see \"Your article was published.\""
	        .Then(() => Site.CurrentPage.Body
	            .Should().Contain("Your article was published."));
	}

[View the full example](https://github.com/xbehave/xbehave.net/blob/master/src/Xbehave.Samples.Net40/BackgroundSample.cs).

This is functionally equivalent to the Gherkin [Background](https://github.com/cucumber/cucumber/wiki/Background) keyword. The background steps are executed before each scenario.