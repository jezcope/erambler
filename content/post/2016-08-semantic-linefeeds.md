---
title: "Semantic linefeeds: one clause per line"
slug: semantic-linefeeds
date: 2016-08-22T21:05:45+01:00
description: |
  Still letting your text editor
  break lines for you at 80 characters?
  Take back control!
draft: false
tags:
- Writing
topics:
- Stuff
type: post
---

I've started using ["semantic linefeeds", a concept I discovered on Brandon Rhodes' blog][source],
when writing content,
an idea described in that article far better than I could.
I turns out this is a very old idea,
promoted way back in the day by Brian W Kernighan,
contributor to the original Unix system,
co-creator of the AWK and AMPL programming languages
and co-author of a lot of seminal programming textbooks
including "The C Programming Language".

The basic idea is
that you break lines at natural gaps between clauses and phrases,
rather than simply after the last word before you hit 80 characters.
Keeping line lengths strictly to 80 characters
isn't really necessary
in these days of wide aspect ratios for screens.
Breaking lines at points that make semantic sense in the sentence
is really helpful for editing,
especially in the context of version control,
because it isolates changes to the clause in which they occur
rather than just the nearest 80-character block.

I also like it because it makes my crappy prose
feel just a little bit more like poetry. ☺

[source]: http://rhodesmill.org/brandon/2012/one-sentence-per-line/
