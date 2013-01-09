---
layout: post
title: Blog Post Excerpts - A New Solution
location: Zurich
excerpt: 400
tags:
- meta
- liquid
---
Something weird happened in the last few days with the Liquid template engine used for GitHub pages.

Previously (last push on 06 Jan), I was using the following code to generate excerpts of each post on the home page.

	{{ "{% capture excerpt " }}%}
		{{ "{% for paragraph in post.content " }}%}{{ "{% if forloop.index0 <= post.excerpt " }}%}{{ "{{ paragraph " }}}}{{ "{% endif " }}%}{{ "{% endfor " }}%}
	{{ "{% endcapture " }}%}
	{{ "{{ excerpt " }}}}

This uses a YAML variable named 'excerpt' in each post which states how many paragraphs to include.

This morning, after I pushed an unrelated change, this code no longer worked and the entire content of each post was being show on the homepage. I [reported the issue to GitHub support](https://gist.github.com/4491164) but at the time of writing I have not yet received a reply.

After coming home from work this evening and investigating further, I noticed that [Henrik Andersson](http://henri.kandersson.com/) had [changed his code to use truncation instead](https://github.com/alfhenrik/henri.kandersson.com/blob/c129f9f5fbb4b5923c1e9e9523496664178e470d/index.html#L15). This seemed like a viable alternative but I didn't like the way each post was potentially truncated mid-word or mid-sentence depending on its content.

Then it struck me - why not combine the two approaches, so that each post still has a variable saying how long the excerpt should be but instead of being a paragraph count, make it a character count? So I changed the excerpt variables in each post accordingly and changed the template code to the following.

	{{ "{{ post.content | truncate: post.excerpt, '' " }}}}

Not only much simpler, but immune to the recent changes made to the GitHub pages Liquid engine!

And normal services resumes...