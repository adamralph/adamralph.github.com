---
layout: post
title: Inheritance by Default Is Backwards
image: /img/handstand-scorpion.jpg
tags:
- .NET
---


Most object-oriented languages make types inheritable by default. That default is backwards. Inheritance is sometimes the right approach, but far less often than its prevalence suggests. A compiler should close types to inheritance by default, and make inheritance the explicit opt-in.

This is not a small stylistic preference. The wrong default shapes the code people write, and it makes the right choice the one you have to remember.

<!--excerpt-->

## The default is backwards

Alan Kay, who coined the term object-oriented programming, put it this way:

> Unfortunately, inheritance—though an incredibly powerful technique—has turned out to be very difficult for novices (and even professionals) to deal with.
>
> — Alan Kay, [_The Early History of Smalltalk_](https://worrydream.com/EarlyHistoryOfSmalltalk/) (1993)

Inheritance is powerful, but it is also a commitment. Once someone derives from a type, changing that type becomes harder. The type was never designed for subclasses, but the compiler invited them anyway. Closing the type later is a breaking change.

Jamie Zawinski's old joke about regular expressions applies with one substitution:

> Some people, when confronted with a problem, think "I know, I'll use inheritance." Now they have two problems, and a base class they can never change.
>
> — after [Jamie Zawinski](https://en.wikiquote.org/wiki/Jamie_Zawinski)

Tutorials do not help: the standard example is still an Animal, a Dog, and a Cat—a hierarchy that exists nowhere else.

The default should make closing a type the easy path, not the afterthought.

Some languages already work this way. Kotlin classes are [`final` by default](https://kotlinlang.org/docs/inheritance.html), and `open` makes them inheritable. Swift requires [`open`](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/) to subclass a class outside its defining module. They are not unusual. They just chose the right default.

## C# gets it backwards

C# makes every class inheritable by default. If you want a class to be closed to inheritance, you have to remember to write `sealed`. Jeffrey Richter, in _CLR via C#_, argues that the default is the wrong way round:

> When defining a new type, compilers should make the class sealed by default so that the class cannot be used as a base class. ... Obviously, it is too late now, but I think that today's compilers have chosen the wrong default and it would be nice if it could change with future compilers.
>
> — Jeffrey Richter, [_CLR via C#_](https://www.microsoftpressstore.com/store/clr-via-c-sharp-9780735667457)

Eric Lippert made the same point in 2004, in [_Why Are So Many Of The Framework Classes Sealed?_](https://learn.microsoft.com/en-us/archive/blogs/ericlippert/why-are-so-many-of-the-framework-classes-sealed): sealing a class after people have derived from it is a breaking change, so the choice has to be made when the class is written.

In C#, `sealed` and `static` close a class to inheritance. `abstract` is the opposite: it says the class is meant to be inherited, but not instantiated. A class that is not `sealed`, `static`, or `abstract` is a potential base class by default.

The C# compiler should do the opposite of what it does today: seal by default, and require `unsealed` to make a class inheritable.

Current compiler behaviour:

| Class kind | Not inheritable | Inheritable |
| --- | --- | --- |
| Not instantiable | `static` | `abstract` |
| Instantiable | `sealed` | default |

Sealed by default:

| Class kind | Not inheritable | Inheritable |
| --- | --- | --- |
| Not instantiable | `static` | `abstract` |
| Instantiable | default | `unsealed` |

`unsealed` is hypothetical; no C# compiler has it today (if `sealed` had never existed, `open` would probably be better than `unsealed`). Switching the default would mean migrating every codebase: adding `unsealed` to every class that is not `sealed`, `static`, or `abstract`, and, for completeness, removing every instance of `sealed`.

`abstract` is not the opt-out for a class that must stay instantiable. It permits inheritance but gives up instantiation. A class that is both instantiable and inheritable would need the explicit opt-out.

## Prior art

This idea has been put to the C# team. In 2020, [csharplang#3235](https://github.com/dotnet/csharplang/issues/3235) asked for classes to be sealed by default unless declared `extendable`. Fred Silberberg, who works on the C# compiler at Microsoft, closed it the same day: a hugely breaking change, with an analyser recommended instead. He said that if he could go back and change C# 1.0, sealing by default would be on his shortlist.<sup><a href="#appendix-a">a</a></sup>
{: #appendix-a-ref}

In 2022, [csharplang#5631](https://github.com/dotnet/csharplang/discussions/5631) proposed a `virtual` class modifier so an analyser could tell which classes were meant to be inherited and which were not. It was closed in 2023 as out of scope for the language, again pointing at an analyser.<sup><a href="#appendix-b">b</a></sup> F# has had the [same suggestion](https://github.com/fsharp/fslang-suggestions/issues/1320), with `[<Sealed(false)>]`, closed as not planned.
{: #appendix-b-ref}

## Removing the default

C# is not going to change its default, but we can effectively remove it with [Sealant](https://www.nuget.org/packages/Sealant), a [.NET source code analysis](https://learn.microsoft.com/dotnet/fundamentals/code-analysis/overview) package that warns with [SEAL0001](https://github.com/adamralph/code-analysis/blob/main/docs/rules/SEAL0001.md) on any class that is not `sealed`, `static`, `abstract`, or marked `unsealed`:

> Type 'Foo' should be sealed, static, abstract, or marked unsealed

The warning (which can be configured to show as an error, for example with [code analysis options](https://learn.microsoft.com/en-us/dotnet/fundamentals/code-analysis/configuration-options#severity-level) or [`TreatWarningsAsErrors`](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/errors-warnings#treatwarningsaserrors)) forces a choice:

- `sealed`, which Sealant's "Seal type" code fix can add.
- `unsealed`, which Sealant's "Mark as unsealed" code fix can add as a comment.

The "Seal type" fix produces:

```csharp
public sealed class Foo
{
}
```

The "Mark as unsealed" fix produces:

```csharp
// unsealed
public class Foo
{
}
```

Every instantiable class ends up explicitly `sealed` or marked `unsealed`. That is how Sealant removes the default. It is also the position Jon Skeet argued for in 2010: [no default at all](https://codeblog.jonskeet.uk/2010/12/01/encapsulation-creative-freedom-control-and-the-balance-of-power), so that a reader can tell whether inheritance was intended or simply never considered.

<aside markdown="1">

An analyser cannot add syntax to C#, so a comment is the closest thing to the real keyword. Some languages allow new syntax—Common Lisp, Racket, and Elixir, for example—but C# does not.

</aside>

### Try it

Install the package. For example, with the .NET CLI:

```shell
dotnet add package Sealant
```

The warning then appears in any IDE that supports .NET source code analysis, once it reloads the project. On the command line, it appears on the next build.

## What's next

Sealant [1.0.0](https://www.nuget.org/packages/Sealant/1.0.0) is out. For feedback, it's usually best to start a [discussion](https://github.com/adamralph/code-analysis/discussions), but you can also [report a bug](https://github.com/adamralph/code-analysis/issues/new?template=bug_report.md) or [request a feature](https://github.com/adamralph/code-analysis/issues/new?template=feature_request.md) directly.

Sealant is the first package in [CodeAnalysis](https://github.com/adamralph/code-analysis), a collection of .NET source code analysis packages. More packages will follow. Probably.

<!-- signoff -->

<section class="appendix" markdown="1">

## Appendix A

In [csharplang#3235](https://github.com/dotnet/csharplang/issues/3235), [a comment](https://github.com/dotnet/csharplang/issues/3235#issuecomment-609035937) pointed at nullable reference types, which are opt in through the project and scoped with directives. Fred Silberberg agreed that was technically possible, but said nullable reference types already introduced "what is effectively a new dialect of C#", and he could not think of anything else worth that cost. <a class="appendix-backlink" href="#appendix-a-ref" aria-label="Back to the reference">↩</a>

</section>

<section class="appendix" markdown="1">

## Appendix B

In [csharplang#5631](https://github.com/dotnet/csharplang/discussions/5631), [a comment](https://github.com/dotnet/csharplang/discussions/5631#discussioncomment-9017647) proposed a project setting, `<SealedClassByDefault>enable</SealedClassByDefault>`, under which the compiler would seal any class that declares no virtual members. It came after the thread had closed, and no proposal followed. <a class="appendix-backlink" href="#appendix-b-ref" aria-label="Back to the reference">↩</a>

</section>
