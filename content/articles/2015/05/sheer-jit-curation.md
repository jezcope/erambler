---
title: "When to curate — sheer vs just-in-time"
kind: article
created_at: Tue 19 May 2015 20:16:11 BST
tags:
- Curation
- Research data management
- Musing
---


## When is the right time to curate?

One of the things that I've been thinking about quite a bit since IDCC 2015 is this: exactly when should curation take place in a digital workflow.

There seem to be two main camps here, though of course it's more of a spectrum than a simple dichotomy.  These two views can be described as "sheer curation" and "just-in-time curation".

## Sheer curation

Sheer curation involves completely and seamlessly integrating curation of data into the workflow itself.  That's "sheer" as in tights: it's such a thin layer that you can barely tell it's there.  The argument here is that the only way to properly capture the context of an artefact is to document it while that context still exists, and this makes a lot of sense.  If you wait until later, the danger is that you won't remember exactly what the experimental conditions for that observation were.  Worse, if you wait long enough you'll forget about the whole thing entirely until it comes time to make use of the data.  Then you run the danger of having to repeat the experiment entirely because you can't remember enough about it for it to be useful.

For this to work, though, you really need it to be as effortless as possible so that it doesn't interrupt the research process.  You also need researchers to have some curation skills themselves, and to minimise the effort required those skills need to be at the stage of [unconscious competence][].  Finally you need a set of tools to support the process.  These do exist, but in most cases they're just not ready for widespread use yet.

[unconscious competence]: http://en.wikipedia.org/wiki/Four_stages_of_competence


## Just-in-time curation

The other extreme is to just do the absolute minimum, and apply the majority of curation effort at the point where someone has requested access.  This is the just-in-time approach: literally making the effort just in time for the data to be delivered.  The major advantage is that there is no wasted effort curating things that don't turn out to be useful.  The alternative is "just-in-case", where you curate before you know what will or won't be useful.

The key downside is the high risk of vital context being lost.  If a dataset is valuable but its value doesn't become apparent for a long time, the researchers who created it may well have forgotten or misplaced key details of how it was collected or processed.  You also need good, flexible tools that don't complain if you leave big holes in your metadata for a long time.

## Comparison

### When might each be useful?

I can see sheer-mode curation being most useful where standards and procedures are well established, especially if value of data can easily be judged up front and disposal integrated into the process.  In particular, this would work well if data capture methods can be automated and instrumented, so that metadata about the context is recorded accurately, consistently and without intervention by the researcher.

Right now this is the case in well-developed data-intensive fields, such as astrophysics and high-energy physics, and newer areas like bioinformatics are getting there too.  In the future, it would be great if this could also apply to any data coming out of shared research facilities (such as chemical characterisation and microscopy).  Electronic lab notebooks could play a big part for observational research, too.

Just-in-time-mode curation seems to make sense where the overheads of curating are high and only a small fraction of collected data is ever reused, so that the return on investment for curation is very low.  It might sometimes be necessary also, if the resources needed for curation aren't actually made available until someone wants to reuse the data.

### Could they be combined?

As I mentioned at the start, these are just two ends of a spectrum of possibilities, and for most situations the ideal solution will lie somewhere in between.  A pragmatic approach would be to capture as much context as is available transparently and up-front (sheer) and then defer any further curation until it is justified.  This would allow the existence of the data to be advertised up-front through its metadata (as required by e.g. the EPSRC expectations), while minimising the amount of effort required.  The clear downside is the potential for delays fulfilling the first request for the data, if such ever comes.
