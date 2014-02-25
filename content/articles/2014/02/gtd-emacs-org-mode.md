---
title: 'Getting Things Done with Emacs and org-mode'
kind: article
created_at: Sat Feb 22 20:13:04 2014
categories:
- Process
tags:
- Productivity
- GTD
- Emacs
- Org-mode
- Task management
- Free software
---


![Gnu](http://farm3.staticflickr.com/2588/3872158703_cdb8e3aacf.jpg){:.main-illustration}

As I've [mentioned previously](/blog/gtd-things-vs-omnifocus), I periodically try out new task management software.  The latest in that story is Emacs and Org-mode.

## What is Org?

In its creator's own words, [Org](http://orgmode.org) is:

> "for keeping notes, maintaining TODO lists, planning projects, and authoring documents with a fast and effective plain-text system"

It started as an Emacs extension for authoring documents with some neat outlining features, then went mad with power and became a complete personal information organiser.

### But wait, what the \*\*\*\* is Emacs?

[Emacs](http://en.m.wikipedia.org/wiki/Emacs) is the mother of all text editors. It's one of the oldest pieces of free software, having been around since the <del>dawn of time</del> 1970's, and is still under active development. Being so venerable, it still cleaves to the conventions of the 70's and is entirely keyboard-controllable (though it now has excellent support for your favourite rodent as well).

"Text editor" is actually a pretty loose term in this instance: it's completely programmable, in a slightly odd language called Elisp (which appeals to my computer scientist side). Because many of the people who use it are programmers, it's been extended to do almost anything that you might want, from transparently editing encrypted or remote (or both) files to browsing the web and checking your email.

## My needs for an organisational system

In my [last productivity-related post](/blog/gtd-things-vs-omnifocus/) I mentioned that the key properties of a task management system were:

* One system for everything
* Multiple ways of structuring and viewing tasks

I would now probably add a third property: the ability to "shrink-wrap", or be as simple as possible for the current situation while keeping extra features hidden until needed.

And Org very much fits the bill.

### One system for everything

Emacs has been ported to pretty much every operating system under the sun, so I know I can use it on my Linux desktop at work, my iMac at home plus whatever I end up with in the future. Because the files are all plain text, they're trivial to keep synchronised between multiple machines.

There are also [apps for iOS and Android](http://orgmode.org/manual/MobileOrg.html), and while they're not perfect, they're good enough for when I want to take my todo list on the road.

### Multiple ways of structuring and viewing tasks

Whatever I'm doing in Emacs, an instant agenda with all my current tasks is only two keystrokes away. That's programmable too, so I have it customised to view my tasks in the way that makes most sense to me.

### Shrink wrapping

Org has a lot of very clever features added by its user community over its 10+ years, but you don't have to use them, or even know they exist, until you need them. As an illustration, a simple task list in Org looks like this:

    * TODO Project 1
    ** TODO Task one
    ** TODO Task two
    
    * TODO Project 2
    ** DONE Another task
    ** TODO A further task

And changing `TODO` to `DONE` is a single keystroke. Simplicity itself.

Here's [Carsten Dominik on the subject](http://article.gmane.org/gmane.emacs.orgmode/6224)

> "[Org-mode] is a zero-setup, totally simple TODO manager that works with plain files, files that can be edited on pretty much any system out there, either as plain text in **any** editor ...
>
> Of course, Org-mode allows you to do more, but I would hope in a non-imposing way!  It has lots of features under the hood that you can pull in when you are ready, when you find out that there is something more you'd like to do."

### Wow, what else can it do?

["I didn't know I could do *that*!"](HTTP://youtu.be/8uF4W29dGLk)

If that's not enough, here are a few more reasons:

* Keyboard shortcuts for quick outline editing
* Lots of detailed organisational tools (but only when you need them):
  * Schedule and deadline dates for tasks
  * Flexible system for repeating tasks/projects
  * Complete tasks in series or parallel
  * Arbitrary properties, notes and tags for tasks and projects
* Use the same tools for [authoring HTML/LaTeX documents](http://orgmode.org/manual/Exporting.html) or even [literate programming](http://orgmode.org/manual/Working-With-Source-Code.html#Working-With-Source-Code)
* It's programmable! If it doesn't have the functionality you want just write it, from adding keyboard shortcuts to whole new use cases (such as a [contact manager](http://julien.danjou.info/projects/emacs-packages#org-contacts) or [habit tracker](http://orgmode.org/manual/Tracking-your-habits.html))

## Give it a try

Emacs is worth trying on its own, especially if you do a lot of programming, web design or anything else that involves a lot of time editing text files. A recent version of Org is bundled with the latest GNU Emacs, and can easily be updated to the current version.

* [GNU Emacs](http://www.gnu.org/software/emacs/)
* [Org-mode](http://orgmode.org/)
