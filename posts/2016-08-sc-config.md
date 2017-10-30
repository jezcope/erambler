---
title: "Software Carpentry: SC Config; write once, compile anywhere"
description: "The SC Config category asked competitors to make it easy to make software that runs on any platform. How did they get on?"
slug: sc-config
date: 2016-08-26T19:47:40+01:00
draft: false
type: post
tags:
- Technology
- Software Carpentry
- Web archaeology
- autoconf
series: swc-archaeology
---

> Nine years ago, when I first release Python to the world, I distributed it with a Makefile for BSD Unix. The most frequent questions and suggestions I received in response to these early distributions were about building it on different Unix platforms. Someone pointed me to autoconf, which allowed me to create a configure script that figured out platform idiosyncracies Unfortunately, autoconf is painful to use -- its grouping, quoting and commenting conventions don't match those of the target language, which makes scripts hard to write and even harder to debug. I hope that this competition comes up with a better solution --- it would make porting Python to new platforms a lot easier!  
> --- *Guido van Rossum, Technical Director, Python Consortium (quote taken from [SC Config page][SC Config])*

On to the next Software Carpentry competition category, then.
One of the challenges of writing open source software
is that you have to make it run on a wide range of systems
over which you have no control.
You don't know what operating system any given user might be using
or what libraries they have installed,
or even what versions of those libraries.

This means that whatever build system you use,
you can't just send the Makefile (or whatever) to someone else
and expect everything to go off without a hitch.
For a very long time,
it's been common practice for source packages to include a `configure` script
that, when executed, runs a bunch of tests to see what it has to work with
and sets up the Makefile accordingly.
Writing these scripts by hand is a nightmare,
so tools like [`autoconf`][autoconf] and [`automake`][automake] evolved
to make things a little easier.

They did, and if the tests you want to use are already implemented
they work very well indeed.
Unfortunately they're built on an unholy combination of
shell scripting and the archaic Gnu M4 macro language.
That means if you want to write new tests
you need to understand both of these
as well as the architecture of the tools themselves
--- not an easy task for the average self-taught research programmer.

[SC Conf][SC Config], then, called for a re-engineering of the autoconf concept,
to make it easier for researchers to make their code available
in a portable, platform-independent format.
The second round configuration tool winner was SapCat,
"a tool to help make software portable".
Unfortunately, this one seems not to have gone anywhere,
and I could only find [the original proposal][SapCat] on the Internet Archive.

[SapCat]: https://web.archive.org/web/20131130123139/http://homepages.rpi.edu/~toddr/Archives/2000/a04g-sapcat-final/SapCat/index.html

There were a lot of good ideas in this category
about making catalogues and databases of system quirks
to avoid having to rerun the same expensive tests again
the way a standard `./configure` script does.
I think one reason none of these ideas survived
is that they were overly ambitions,
imagining a grand architecture
where their tool provide some overarching source of truth.
This is in stark contrast to the way most Unix-like systems work,
where each tool does one very specific job well
and tools are easy to combine in various ways.

In the end though, I think Moore's Law won out here,
making it easier to do the brute-force checks each time
than to try anything clever to save time
--- a good example of avoiding unnecessary optimisation.
Add to that the evolution of the generic [`pkg-config`][pkg-config] tool
from earlier package-specific tools like `gtk-config`,
and it's now much easier to check for
particular versions and features of common packages.

On top of that,
much of the day-to-day coding of a modern researcher
happens in interpreted languages like Python and R,
which give you a fully-functioning pre-configured environment
with a lot less compiling to do.

As a side note, [Tom Tromey][],
another of the shortlisted entrants in this category,
is still a major contributor to the open source world.
He still seems to be involved in the automake project,
contributes a lot of code to the emacs community too
and blogs sporadically at [The Cliffs of Inanity][].

[SC Config]: https://web.archive.org/web/20071014042737/http://software-carpentry.com/sc_config/index.html
[autoconf]: https://www.gnu.org/software/autoconf/autoconf.html
[automake]: https://www.gnu.org/software/automake/
[SapCat]: https://web.archive.org/web/20131130123139/http://homepages.rpi.edu/~toddr/Archives/2000/a04g-sapcat-final/SapCat/index.html
[pkg-config]: https://www.freedesktop.org/wiki/Software/pkg-config/
[Tom Tromey]: https://github.com/tromey
[The Cliffs of Inanity]: http://tromey.com/blog/
