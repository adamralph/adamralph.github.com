---
layout: post
title: Packaging a package-specific Roslyn analyzer
location: Flims
tags: NuGet
---
Some [Roslyn-based analyzers for .NET](https://docs.microsoft.com/en-us/dotnet/standard/analyzers/) are general in nature. They tend to focus on coding style, language use, or platform APIs. Others may be specific to a NuGet package. A package-specific analyzer provides messages and fixes tailored to use of that package. This is a great way for package authors to help improve your code or avoid even nasty bugs in production. Many popular open source packages are now shipping with a complementary analyzer. Today, I'm going to take a look at how we can package these package-specific analyzers.

I've seen three methods in use:

<!--excerpt-->

## Method 1: a separate package

The main advantage of this approach is independent release. We can change the analyzer without changing the main package. Also, users are not forced to use the analyzer. They have to "opt-in".

The big disadvantage is that many (most?) users will not opt-in. They may not know about the analyzer, or may choose not to use it. Low adoption can be a problem. There may be something that users often get wrong when using the main package. We design our APIs and docs to lead users in the right direction. But there are some problems only a code review (or an analyzer) can catch.

## Method 2: a separate package, depended on by the main package

When users install the main package, they get the analyzer thrown in. That means 100% of users are using the analyzer! The downside is that there is no way to "opt-out".

There's also a bigger problem with this method. The user's project has a direct dependency on the main package, but only a "transitive dependency" on the analyzer package. The main package depends on the analyzer package with a version range. A typical version range may be "greater than or equal to", e.g `>= 1.0.0`. NuGet resolves transitive dependencies using the lowest version that satisfies the version range, i.e. `1.0.0`. Now let's say we discover a bug in the analyzer and release `1.0.1`. Our users are not prompted to update to the new version because their project does not depend on the analyzer. The only way for users to get the new version of the analyzer is to actually install it. Now we are back to a similar situation as method 1. Users have to "opt-in" to the new version of the analyzer. We could avoid that by releasing a new version of the main package which depends on the new version of the analyzer package. But that means we've lost the advantage of independent release.

## Method 3: part of the main package

With this method, we include the analyzer assembly in the main package, in the `analyzers` folder. We have the benefit of method 2, in that 100% of users are using the analyzer. When we release new versions of the analyzer, we are releasing the main package, which prompts users to update. Again, we don't have opt-out for the analyzer, nor do we have independent release.

## Conclusion

When choosing the best method to use, the most important factor may be the _importance_ of the diagnostics provided by the analyzer. If the analyzer detects problems which affect production apps, I'd favour method 3. Otherwise, I'd go for method 1. I'm having difficulty seeing method 2 as a good choice in any scenario. It offers nothing over method 3, since independent release of the analyzer is ineffective. One argument against method 3 is that analyzer changes are not enough to warrant a release of the main package. I'd argue against this. If we've already chosen method 3, then a fix to the analyzer may be as, or even more, important as a fix to the referenced assemblies.

It's possible that the big problem with method 2 could be solved by changing NuGet. We could [allow a package to depend on the highest available version of another package](https://github.com/NuGet/Home/issues/1192). NuGet could also prompt for updates to transitive dependencies.

Do you disagree? Have you seen other methods of packaging package-specific analyzers? Please sound off in the comments!
