---
title: "Implementing Yesterbox in emacs with mu4e"
description: "\"Yesterbox\" is a clever system for managing email that involves hiding today's new email. Turns out that's trivial to implement in emacs."
slug: yesterbox-emacs-mu4e
date: 2016-10-27T08:30:33+01:00
draft: false
type: post
topics:
- Technology
tags:
- Emacs
- Productivity
- Email
---

I've been meaning to give [Yesterbox][] a try for a while.
The general idea is
that each day you only deal with email that arrived
yesterday or earlier.
This forms your inbox for the day,
hence "yesterbox".

[Yesterbox]: http://www.yesterbox.com/

Once you've emptied your yesterbox,
or at least got through some minimum number
(10 is recommended)
*then* you can look at emails from today.
Even then you only really want to be dealing with
things that are absolutely urgent.
Anything else can wait til tomorrow.

The motivation for doing this
is to get away from the feeling that we are King Canute,
trying to hold back the tide.
I find that when I'm processing my inbox toward zero
there's always a temptation to keep skipping to the new stuff that's just come in.
Hiding away the new email
until I've dealt with the old
is a very interesting idea.

I use [mu4e][] in emacs for reading my email,
and handily the mu search syntax is very flexible
so you'd think it would be easy
to create a yesterbox filter:

```
maildir:"/INBOX" date:..1d
```

[mu4e]: http://www.djcbsoftware.nl/code/mu/mu4e.html

Unfortunately,
`1d` is interpreted as "24 hours ago from right now"
so this filter misses everything that was sent
yesterday but *less than* 24 hours ago.
There was a feature request raised on the mu github repository
to [implement an additional date filter syntax](https://github.com/djcb/mu/issues/582)
but it seems to have died a death for now.
In the meantime,
the answer to this is to remember that
my workplace observes fairly standard office hours,
so that anything sent more than 9 hours ago
is unlikely to have been sent today.
The following does the trick:

```
maildir:"/INBOX" date:..9h
```

In my mu4e bookmarks list,
that looks like this:

```emacs-lisp
(setq mu4e-bookmarks
      '(("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
        ("flag:flagged maildir:/archive" "Starred messages" ?s)
        ("date:today..now" "Today's messages" ?t)
        ("date:7d..now" "Last 7 days" ?w)
        ("maildir:\"/Mailing lists.*\" (flag:unread OR flag:flagged)" "Unread in mailing lists" ?M)
        ("maildir:\"/INBOX\" date:..1d" "Yesterbox" ?y))) ;; <- this is the new one
```
