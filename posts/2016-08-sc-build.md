---
title: 'Software Carpentry: SC Build; or making a better make'
description: "Entrants to the SC Build category were invited to create a replacement for the venerable make tool. How did they do?"
slug: sc-build
date: 2016-08-19T19:30:13+01:00
draft: false
type: post
tags:
- Technology
- Software Carpentry
- Web archaeology
- SCons
- Python
- Make
series: swc-archaeology
---

> Software tools often grow incrementally from small beginnings into elaborate artefacts. Each increment makes sense, but the final edifice is a mess. make is an excellent example: a simple tool that has grown into a complex domain-specific programming language. I look forward to seeing the improvements we will get from designing the tool afresh, as a whole...  
> --- *Simon Peyton-Jones, Microsoft Research (quote taken from [SC Build page][SC Build])*

Most people who have had to compile an existing software tool
will have come across the venerable [`make`][make] tool
(which usually these days means [GNU Make][]).
It allows the developer to write a declarative set of rules
specifying how the final software should be built
from its component parts,
mostly source code,
allowing the build itself to be carried out
by simply typing `make` at the command line and hitting `Enter`.

Given a set of rules,
`make` will work out all the dependencies between components
and ensure everything is built in the right order
and nothing that is up-to-date is rebuilt.
Great in principle
but `make` is notoriously difficult for beginners to learn,
as much of the logic for how builds are actually carried out
is hidden beneath the surface.
This also makes it difficult to debug problems
when building large projects.
For these reasons,
the [*SC Build* category][SC Build] called for a replacement build tool
engineered from the ground up to solve these problems.

The second round winner, ScCons,
is a [Python-based make-like build tool][SCons]
written by Steven Knight.
While I could find no evidence of any of the other shortlisted entries,
this project (now renamed SCons)
continues in active use and development to this day.

I actually use this one myself from time to time
and to be honest I prefer it in many cases
to trendy new tools like [rake][] or [grunt][]
and the behemoth that is [Apache Ant][].
Its Python-based `SConstruct` file syntax is remarkably intuitive
and scales nicely from very simple builds
up to big and complicated project,
with good dependency tracking to avoid unnecessary recompiling.
It has a lot of built-in rules for performing common build & compile tasks,
but it's trivial to add your own,
either by combining existing building blocks
or by writing a new builder with the full power of Python.

A minimal `SConstruct` file looks like this:

```python
Program('hello.c')
```

Couldn't be simpler!
And you have the full power of Python syntax
to keep your build file simple and readable.

It's interesting that all the entries in this category apart from one
chose to use a Python-derived syntax for describing build steps.
Python was clearly already a language of choice
for flexible multi-purpose computing.
The exception is the entry that chose to use XML instead,
which I think is a horrible idea
(oh how I used to love XML!)
but has been used to great effect in the Java world
by tools like Ant and Maven.

[make]: https://en.wikipedia.org/wiki/Make_(software)
[GNU make]: https://www.gnu.org/software/make/
[SC Build]: https://web.archive.org/web/20061116215358/http://www.software-carpentry.com/sc_build/index.html
[SCons]: http://scons.org/
[rake]: http://rake.rubyforge.org/
[grunt]: http://gruntjs.com/
[Apache Ant]: https://ant.apache.org/
