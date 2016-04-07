---
title: 'Wiring my web'
kind: article
created_at: Thursday Apr 2016 17:37:00 BST
tags:
- APIs
- Web
- Automation
- IFTTT
---

I'm a nut for automating repetitive tasks, so I was dead pleased a few years ago when I discovered that [IFTTT](https://ifttt.com) let me plug different bits of the web together. I now use it for tasks such as:

- Syndicating blog posts to social media
- Creating scheduled/repeating todo items from a Google Calendar
- Making a note to revisit an article I've starred in Feedly

I'd probably only be half-joking if I said that I spend more time automating things than I save not having to do said things manually. Thankfully it's also a great opportunity to learn, and recently I've been thinking about reimplementing some of my IFTTT workflows myself to get to grips with how it all works.

![XKCD: automation](http://imgs.xkcd.com/comics/automation.png)

There are some interesting open source projects designed to offer a lot of this functionality, such as [Huginn](https://github.com/cantino/huginn), but I decided to go for a simpler option for two reasons:

1. I want to spend my time learning about the APIs of the services I use and how to wire them together, rather than learning how to use another big framework; and 
2. I only have a small Amazon EC2 server to pay with and a heavy Ruby on Rails app like Huginn (plus web server) needs more memory than I have.

Instead I've gone old-school with a little collection of individual scripts to do particular jobs. I'm using the built-in scheduling functionality of systemd, which is already part of a modern Linux operating system, to get them to run periodically. It also means I can vary the language I use to write each one depending on the needs of the job at hand and what I want to learn/feel like at the time. Currently it's all done in Python, but I want to have a go at Lisp sometime, and there are some interesting new languages like Go and Julia that I'd like to get my teeth into as well.

You can see my code on github as it develops: <https://github.com/jezcope/web-plumbing>. Comments and contributions are welcome (if not expected) and let me know if you find any of the code useful.
