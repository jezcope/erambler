---
title: "Changing static site generators: Nanoc → Hugo"
author: Jez Cope
date: 2016-08-12T13:18:28+01:00
slug: changing-static-site-generators-nanoc-hugo
description: |
  In which I continue to avoid actually writing
  by moving to a new static site generator
draft: false
tags:
- Meta
- Web
type: post
---

I've decided to move the site over to a different static site generator,
[Hugo](http://gohugo.io/).
I've been using [Nanoc](http://nanoc.ws) for a long time and it's worked very well,
but lately it's been taking longer and longer to compile the site
and throwing weird errors that I can't get to the bottom of.

At the time I started using Nanoc, static site generators were in their infancy.
There weren't the huge number of feature-loaded options that there are now,
so I chose one and I built a whole load of blogging-related functionality myself.
I did it in ways that made sense at the time
but no longer work well with Nanoc's latest versions.

So it's time to move to something that has blogging baked-in from the beginning
and I'm taking the opportunity to overhaul the look and feel too.
Again, when I started there weren't many pre-existing themes
so I built the whole thing myself
and though I'm happy with the work I did on it
it never quite felt polished enough.
Now I've got the opportunity
to adapt one of the many well-designed themes already out there,
so I've taken one from the [Hugo themes gallery](http://themes.gohugo.io)
and tweaked the colours to my satisfaction.

Hugo also has various features that I've wanted to implement in Nanoc
but never quite got round to it.
The nicest one is proper handling of draft posts and future dates,
but I keep finding others.

There's a lot of old content that isn't *quite* compatible with the way Hugo does things
so I've taken the old Nanoc-compiled content and frozen it
to make sure that old links should still work.

I could probably fiddle with it for years without doing much
so it's probably time to go ahead and publish it.
I'm still not completely happy with my choice of theme
but one of the joys of Hugo is that I can change that whenever I want.

Let me know what you think!
