---
title: Twitter favourites by daily email
kind: article
created_at: Sun Jan 27 19:14:41 2013
categories:
- Social media
tags:
- Twitter
- Email
- GTD
- Productivity
- Tech recipe
---

I quite often favourite tweets that I want to come back and refer to. Unfortunately, I rarely actually get round to going back over my favourite tweets, so I wanted a way to get them into an inbox that I check regularly (á la [Getting Things Done](http://wiki.43folders.com/index.php/Getting_Things_Done)).

I finally got round to figuring this out the other day, so here's my recipe:

1.  You can get an RSS feed of your favourites using a URL of the form [`https://api.twitter.com/1/favorites.rss?screen_name=jezcope`](https://api.twitter.com/1/favorites.rss?screen_name=jezcope), though obviously you should replace "jezcope" with your own Twitter handle.
    -   [Source: Twitter developers forum](https://dev.twitter.com/discussions/4759)
2.  Once you've checked that's working, copy it and feed it to a daily email digest generator. I'm currently trying [blogtrottr](http://blogtrottr.com/) which seems to be working well and gives you the option of checking at a range of frequencies from 1 to 24 hours.
    -   There's also a [list of RSS to email options on the old Feed My Inbox site](http://www.feedmyinbox.com/)

That's it — pretty simple huh? You'll probably get an email containing all of your favourites to start, and then future emails will contain just the latest favourites.
