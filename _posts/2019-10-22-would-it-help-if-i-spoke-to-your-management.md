---
layout: post
title: Would it help if I spoke to your management?
description: An important responsibility we have as software developers is to identify the root problem.
image: /img/manager.jpg
location: Flims
tags:
- teamwork
---

<img src="/img/manager.jpg" />

An important responsibility we have as software developers is to identify the root problem. We're often faced with problems which, at first glance, appear technical. When a race condition appears, we start writing code to remove it. When we're told two business operations must be consistent, we find ingenious new ways of implementing distributed transactions.<!--excerpt-->

But when we ask _why?_, the immediate problem so often disappears.

Recently, I had an interesting conversation during my shift running the "chat with a developer" feature on the [Particular Software website](https://particular.net).

**Me:**

<blockquote>
  <p>Hello, how may I help?</p>
</blockquote>

**Visitor:**

<blockquote>
  <p>Hey Adam</p>
  <p>Quick question</p>
  <p>ConfigureHowToFindSaga. Can this method be tested?</p>
  <p>If yes, how?</p>
</blockquote>

An alarm bell started to ring. `ConfigureHowToFindSaga` is a `protected abstract` method in NServiceBus. I usually wouldn't aim to test it in isolation. The test would repeat the production code, and wouldn't prove anything.

**Visitor:**

<blockquote>
  <p>I know it sounds silly, coz all handlers are tested, but we are looking for 100% test coverage for management. 😀</p>
</blockquote>

The alarm bell was now deafening.

**Me:**

<blockquote>
  <p>Hi {name omitted}, I guess this is not the answer you want to hear, but the goal of 100% test coverage is the problem here, and that is the problem I would aim to solve.</p>
  <p>Your test would just be a repeat of the production code.</p>
</blockquote>

**Visitor:**

<blockquote>
  <p>Exactly i understand that as a developer. 🙂</p>
</blockquote>

At this point, I started to feel sorry for this person. They understand why a goal of 100% test coverage is usually a bad idea, but their hands are tied by management. I cut to the chase:

**Me:**

<blockquote>
  <p>Would it help if I spoke to your management?</p>
</blockquote>

When the chat started, I was in the middle of a pairing session with a colleague over a video call. When I wrote this line, he snorted with laughter. True, the comment was a little tongue-in-cheek, but I felt compelled to write it. My correspondent saw the funny side and declined the offer with a laughing emoji, but he said he would go back to management and challenge the rule.

The following weekend, I was out hiking and thinking about the conversation (yes, I have trouble switching off). It dawned on me that this wasn't such a silly offer after all. I played out an imaginary conversation with management in my head, and realised how valuable the conversation could have been. After all, if _management_ is causing the problem, why not fix _management_?

When I'm posed a problem through chat, a support request, or at a conference or user group, I try to emphasise my effort to find the root cause. I often manage to convert a low level technical problem into a higher level reconsideration. In turn, a better approach emerges which avoids the technical problem and brings further benefits.

The next time I'm in a similar conversation, I may make the same offer again. Who knows? Maybe someone will take me up on it.
