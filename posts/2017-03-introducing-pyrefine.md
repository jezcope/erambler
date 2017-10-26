---
title: "Introducing PyRefine: OpenRefine meets Python"
description: "I'm knocking the rust off my programming skills by attempting to write a pure-Python interpreter for OpenRefine \"scripts\"."
slug: introducing-pyrefine-openrefine-python
date: 2017-03-27T21:00:56+01:00
draft: false
type: post
topics:
- Technology
tags:
- Python
- OpenRefine
- Data
- Data cleaning
- Experiment
---

I'm knocking the rust off my programming skills by attempting to write
[a pure-Python interpreter for OpenRefine "scripts"][pyrefine].

{{% figure alt="OpenRefine logo"
src="https://upload.wikimedia.org/wikipedia/commons/7/76/Google-refine-logo.svg"
link="http://openrefine.org"
class="main-illustration fr" %}}

**[OpenRefine](http://openrefine.org) is a great tool
for exploring and cleaning datasets prior to analysing them**.
It also records an undo history of all actions
that you can export as a sort of script in [JSON](http://en.wikipedia.org/wiki/JSON) format.
One thing that bugs me though is that,
having spent some time interactively cleaning up your dataset,
you then need to fire up OpenRefine again
and do some interactive mouse-clicky stuff
to apply that cleaning routine to another dataset.
You can at least re-import the JSON undo history to make that as quick as possible,
but there's no getting around the fact that
there's no quick way to do it from a cold start.

There is a project,
[BatchRefine, that extends the OpenRefine server to accept batch requests over a HTTP API][BatchRefine],
but that isn't useful when you can't or don't want to keep
a full Java stack running in the background the whole time.

[BatchRefine]: https://github.com/fusepoolP3/p3-batchrefine

My concept is this:
you use OR to explore the data interactively and design a cleaning process,
but then **export the process to JSON and integrate it into your analysis in Python**.
That way it can be repeated *ad nauseam* without having to fire up a full Java stack.

I'm taking some inspiration from the great talk
["So you want to be a wizard?"][wizard]
by [Julia Evans (@b0rk)][b0rk],
who recommends **trying experiments as a way to learn**.
She gives these Rules of Programming Experiments:

> - "it doesn't have to be good
> - it doesn't have to work
> - you have to learn something"

[wizard]: http://jvns.ca/blog/so-you-want-to-be-a-wizard/
[b0rk]: https://twitter.com/b0rk 

In that spirit, my main priorities are:
**to see if this can be done;
to see how far I can get implementing it;
and to learn something**.
If it also turns out to be a useful thing,
well, that's a bonus.
Some of the interesting possible challenges here:

- Implement all core operations;
  there are quite a lot of these,
  some of which will be fun (i.e. non-trivial) to implement
- Implement (a subset of?)
  [GREL, the General Refine Expression Language][GREL];
  I guess my undergrad course on implementing parsers and compilers will come in handy after all!
- Generate clean, sane Python code from the JSON
  rather than merely executing it;
  more than anything,
  this would be a nice educational tool for users of OpenRefine
  who want to see how to do equivalent things in Python
- Selectively optimise key parts of the process;
  this will involve profiling the code to identify bottlenecks
  as well as tweaking the actual code to go faster
- Potentially handle contributions to the code from other people;
  I'd be really happy if this happened but I'm realistic...

If you're interested,
the [project is called PyRefine and it's on github][pyrefine].
Constructive criticism, issues & pull requests all welcome!

[GREL]: https://github.com/OpenRefine/OpenRefine/wiki/General-Refine-Expression-Language
[pyrefine]: https://github.com/jezcope/pyrefine
