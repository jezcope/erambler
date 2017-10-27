---
title: Tools for collaborative markdown editing
slug: collaborative-markdown-editing
author: Jez
date: 2016-09-15T20:52:35+01:00
description: "I can't believe it's taken this long to create tools that allow simultaneous editing of markdown documents, but they're finally here."
draft: false
topics:
- Research communication
- Technology
tags:
- Markdown
- Collaboration
type: post
---

{{% figure alt="Discount signs in a shop window"
src="https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Half_off_original_price.jpg/640px-Half_off_original_price.jpg"
class="main-illustration fr"
attr="Photo by Alan Cleaver"
attrlink="https://en.wikipedia.org/wiki/File:Half_off_original_price.jpg" %}}

I really love [Markdown](https://en.wikipedia.org/wiki/Markdown)[^1]. I love its simplicity; its readability; its plain-text nature. I love that it can be written and read with nothing more complicated than a text-editor. I love how nicely it plays with version control systems. I love how easy it is to convert to different formats with Pandoc and how it's become effectively the native text format for a wide range of blogging platforms.

[^1]: Other plain-text formats are available. I'm also a big fan of [org-mode](http://orgmode.org/).

One frustration I've had recently, then, is that it's surprisingly difficult to collaborate on a Markdown document. There are various solutions that *almost* work but at best feel somehow inelegant, especially when compared with rock solid products like Google Docs. Finally, though, we're starting to see some real possibilities. Here are some of the things I've tried, but I'd be keen to hear about other options.

## 1. Just suck it up

To be honest, [Google Docs](https://docs.google.com/) isn't *that* bad. In fact it works really well, and has almost no learning curve for anyone who's ever used Word (i.e. practically anyone who's used a computer since the 90s). When I'm working with non-technical colleagues there's nothing I'd rather use.

It still feels a bit uncomfortable though, especially the vendor lock-in. You can export a Google Doc to Word, ODT or PDF, but you need to use Google Docs to do that. Plus as soon as I start working in a word processor I get tempted to muck around with formatting.

## 2. Git(hub)

The obvious solution to most techies is to set up a [GitHub](https://github.com/) repo, commit the document and go from there. This works very well for bigger documents written over a longer time, but seems a bit heavyweight for a simple one-page proposal, especially over short timescales.

Who wants to muck around with pull requests and merging changes for a document that's going to take 2 days to write tops? This type of project doesn't need a bug tracker or a wiki or a public homepage anyway. Even without GitHub in the equation, using git for such a trivial use case seems clunky.

## 3. Markdown in Etherpad/Google Docs

[Etherpad](http://etherpad.org/) is great tool for collaborative editing, but suffers from two key problems: no syntax highlighting or preview for markdown (it's just treated as simple text); and you need to find a server to host it or do it yourself.

However, there's nothing to stop you editing markdown with it. You can do the same thing in Google Docs, in fact, and I have. Editing a fundamentally plain-text format in a word processor just feels weird though.

## 4. Overleaf/Authorea

[Overleaf](http://overleaf.com/) and [Authorea](http://authorea.com/) are two products developed to support academic editing. Authorea has built-in markdown support but lacks proper simultaneous editing. Overleaf has great simultaneous editing but only supports markdown by wrapping a bunch of LaTeX boilerplate around it. Both OK but unsatisfactory.

## 5. StackEdit

Now we're starting to get somewhere. [StackEdit](https://stackedit.io/) has both Markdown syntax highlighting and near-realtime preview, as well as integrating with Google Drive and Dropbox for file synchronisation.

## 6. HackMD

[HackMD](https://hackmd.io/) is one that I only came across recently, but it looks like it does exactly what I'm after: a simple markdown-aware editor with live preview that also permits simultaneous editing. I'm a little circumspect simply because I know simultaneous editing is difficult to get right, but it certainly shows promise.

## 7. Classeur

I discovered [Classeur](https://classeur.io/) literally today: it's developed by the same team as StackEdit (which is now apparently no longer in development), and is currently in beta, but it looks to offer two killer features: real-time collaboration, including commenting, and pandoc-powered export to loads of different formats.

## Anything else?

Those are the options I've come up with so far, but they can't be the only ones. Is there anything I've missed?
