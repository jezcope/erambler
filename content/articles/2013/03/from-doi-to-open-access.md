---
title: Resolving DOIs with green OA copies
kind: article
created_at: 2013-03-07 19:58
categories:
- Things I made
tags:
- DOI
- Open access
- Open scholarship
- OAI-PMH
- Programming
- Ruby
- Sinatra
---

The other week I was at a [gathering of developers, librarians and researchers with an interest in institutional data repositories][CKAN workshop]. Amongst other things, we spent some time brainstorming the requirements for such a repository, but there was one minor-sounding one that caught my imagination.

It boiled down to this question: given only the [DOI][] for a published article (or other artefact), how do you find an open access copy archived in an institutional repository? Some (rather cursory) Googling didn't come up with an obvious solution, so I thought "How hard can it be to implement?".

All that's required is a database mapping DOIs onto URLs, and a spot of glue to make it accessible over the web. The data that you need is freely available in machine-readable format from most repositories via [OAI-PMH][], so you can fill up the database using that as a data source.

So, without further ado here it is:

- [Open Access DOI resolver](http://doi2oa.erambler.co.uk)

A few caveats:

1. I don't get much chance to write code at work at the moment, so this was an opportunity to exercise under-used brain muscles and learn some new stuff. It could probably be done better (and the [source code][] is on github, so feel free to fork it and add improvements). It's written in [Ruby][] using the awesome [Sinatra][] web framework.
2. It's currently hosted on [Heroku][]'s free starter-level service, so there's very little capacity. It therefore only includes DOI's from the University of Bath's [Opus](http://opus.bath.ac.uk) repository, and the database is full.

Go try it out and let me know what you think. If it's useful, I'll look into how I can make it more robust and resolve more DOIs.

[CKAN workshop]: http://orbital.blogs.lincoln.ac.uk/2013/02/27/ckan-for-rdm-workshop/
[DOI]: http://en.wikipedia.org/wiki/Digital_object_identifier
[OAI-PMH]: http://en.wikipedia.org/wiki/Open_Archives_Initiative_Protocol_for_Metadata_Harvesting
[source code]: http://github.com/jezcope/doi2oa
[Ruby]: http://ruby-lang.org/
[Sinatra]: http://sinatrarb.com/
[Heroku]: http://heroku.com/
