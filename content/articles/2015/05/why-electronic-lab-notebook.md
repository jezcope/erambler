---
title: "Why use an electronic lab notebook?"
kind: article
created_at: Wed 13 May 2015 19:46:58 BST
tags:
- eScience
- Electronic lab notebook
- Research data management
- eResearch
---

*The sharp-eyed amongst you will have noticed I've recently ended a bit of a break in service on this blog.  I've been doing that thing of half-writing posts and then never finishing them, so I've decided to clear out the pipeline and see what's still worth publishing.  This is a slightly-longer-than-usual piece I started writing about 9 months ago, still in my previous job.  It still seems relevant, so here you go.  You're welcome.*

## What is an electronic lab notebook?

For the last little while at work, I've been investigating the possibility of implementing an electronic lab notebook (ELN) system, so here are a few of my thoughts on what an ELN actually is.

### What is a lab notebook?

All science is built on *data*[^theoretical]. Definitions of "data" vary, but they mostly boil down to this: data is evidence gathered through observation (direct or via instruments) of real-world phenomena.

[^theoretical]: Yes, even theoretical science, in my humble opinion. I know, I know. The comment section is open for debate.

A lab notebook is the traditional device for recording scientific data before it can be processed, analysed and turned into conclusions. It is typically a hardback notebook, A4 size (in the UK at least) with sequentially numbered pages recording the method and conditions of each experiment along with any measurements and observations taken during that experiment.

In industrial contexts, where patent law is king, all entries must be in indelible ink and various arcane procedures followed, such as the daily signing of pages by researcher and supervisor; even in academia some of these precautions can be sensible.

But the most important think about a lab notebook is that it records *absolutely everything* about your research project for future reference. If any item of data is missing, the scientific record is incomplete and may be called into question. At best this is frustrating, as time-consuming and costly work must be repeated; at worst, it leaves you open to accusations of scientific misconduct of the type perpetrated by [Diederik Stapel](http://en.m.wikipedia.org/wiki/Diederik_Stapel).

### So what's an *electronic* lab notebook?

An ELN, then, is some (any?) system that gives you the affordances I've described above while being digital in nature.  In practice, this means a notebook that's accessed via a computer (or, increasingly, a mobile device such as a tablet or smartphone), and stores information in digital form.

This might be a dedicated native app (this is the route taken by most industrial ELN options), giving you a lot of functionality right on your own desktop.  Alternatively, it might be web-based, accessed using your choice of browser without any new software to be installed at all.

It might be standalone, existing entirely on a single computer/device with no need for network access.  Alternatively it might operate in a client-server configuration, with a central database providing all the storage and processing power, and your own device just providing a window onto that.

These are all implementation details though.  The important thing is that you can record your research using it.  By why? What's the point?

### What's wrong with paper?

Paper lab notebooks work perfectly well already, don't they? We've been using them for hundreds of years.

While paper has a lot going for it (it's cheap and requires no electricity or special training to use), it has its disadvantages too. It's all too easy to lose it (maybe on a train) or accidentally destroy it (by spilling nasty organic solvents on it, or just getting caught out in the rain).

At the same time, it's very difficult to safeguard in any meaningful sense, short of scanning or photocopying each individual page.

It's hard to share: an increasingly important factor when collaborative, multidisciplinary research is on the rise. If I want to share my notes with you, I either have to post you the original (risky) or make a physical or digital copy and send that.

Of more immediate relevance to most researchers, it's also difficult to interrogate unless you're some kind of an indexing ninja.  When you can't remember exactly what page recorded that experiment nine months ago, you're in for a dull few hours searching through page-by-page.

### What can a good ELN give us?

The most obvious benefit is that all of your data is now digital, and can therefore be backed up to your heart's content.  Ideally, all data is stored on a safe, remote server and accessed remotely, but even if it's stored directly on your laptop/tablet you now have the option of backing it up.  Of course, the corollary is that you have to make sure you *are* backing up, otherwise you'll look a bit silly when you drop your laptop in a puddle.

The next benefit of digital is that it can be indexed, categorised and searched in potentially dozens of different dimensions, making it much easier to find what you were looking for and collect together sets of related information.

A good electronic system can do some useful things to support the integrity of the scientific record.  Many systems can track all the old versions of an entry.  As well as giving you an important safety net in case of mistakes, this also demonstrates the evolution of your ideas.  Coupled with some cryptographic magic and digital signatures, it's even possible to freeze each version to use as evidence in a court of law that you had a given idea on a given day.

Finally, moving notes and data to a digital platform can set them free.  Suddenly it becomes trivial to share them with collaborators, whether in the next room or the next continent.  While some researchers advocate fully "open notebook science" --- where all notes and data are made public as soon as possible after they're recorded --- not everyone is comfortable with that, so some control over exactly *who* the notebook is shared with is useful too.

### What are the potential disadvantages?

The first thing to note is that a poorly implemented ELN will just serve to make life more awkward, adding extra work for no gain.  This is to be avoided at all costs --- great care must be taken to ensure that the system is appropriate to the people who want to use it.

It's also true that going digital introduces some potential new risks.  We've all seen the...  My own opinion is that there will always be risks, whether data is stored in the cloud or on dead trees in a filing cabinet.  As long as those risks are understood and appropriate measures taken to mitigate them, digital data can be much safer than the average paper notebook.

One big stumbling block that still affects a lot of the ELN options currently available is that they assume that the users will have network access.  In the lab, this is unlikely to be a problem, but how about on the train?  On a plane or in a foreign country?  A lot of researchers will need to get work done in a lot of those places.  This isn't an easy problem to solve fully, though it's often possible with some forethought to export and save individual entries to support remote working, or to make secure use of mobile data or public wireless networks.

### Summary

So there you have it.  In my humble opinion, a well-implemented ELN provides so many advantages over the paper alternative that it's a no-brainer, but that's certainly not true for everyone.  Some activities, by their very nature, work better with paper, and either way most people are very comfortable with their current ways of working.

What's your experience of note-taking, within research or elsewhere?  What works for you?  Do you prefer paper or bits, or a mixture of the two?
