---
title: "Replacing comments with webmentions"
description: "In which I rip out Disqus in favour of something decentralised and free (as in speech)"
slug: replacing-comments-with-webmentions
date: 2020-01-16T20:42:50+00:00
type: post
tags:
- Open culture
- IndieWeb
- DWeb
- Fediverse
---

Just a quickie to say that I've replaced the comment section at the bottom of each post with [webmentions][], which allows you to comment by posting on your own site and linking here. It's a fundamental part of the [IndieWeb][], which I'm slowly getting to grips with having been a halfway member of it for years by virtue of having my own site on my own domain.

I'd already got rid of Google Analytics to stop forcing that tracking on my visitors, I wanted to get rid of Disqus too because I'm pretty sure the only way that is free for me is if they're selling my data and yours to third parties. Webmention is a nice alternative because it relies only on open standards, has no tracking and allows people to control their own comments. While I'm currently using a third-party service to help, I can switch to self-hosted at any point in the future, completely transparently.

Thanks to [webmention.io][], which handles incoming webmentions for me, and [webmention.js][], which displays them on the site, I can keep it all static and not have to implement any of this myself, which is nice. It's a bit harder to comment because you have to be able to host your own content somewhere, but then almost no-one ever commented anyway, so it's not like I'll lose anything! Plus, if I get [Bridgy][] set up right, you should be able to comment just by replying on Mastodon, Twitter or a few other places.

A spot of web searching shows that I'm not the first to make the Disqus -> webmentions switch (yes, I'm putting these links in blatantly to test outgoing webmentions with [Telegraph][]...):

- [So long Disqus, hello webmention --- Nicholas Hoizey](https://nicolas-hoizey.com/articles/2017/07/so-long-disqus-hello-webmentions/)
- [Bye Disqus, hello Webmention! --- Evert Pot](https://evertpot.com/bye-disqus-hello-webmention/)
- [Implementing Webmention on a static site --- Deluvi](https://deluvi.com/blog/webmention/)

Let's see how this goes!

[webmentions]: https://indieweb.org/Webmention
[IndieWeb]: https://indieweb.org/
[webmention.io]: https://webmention.io/
[webmention.js]: https://github.com/PlaidWeb/webmention.js
[Bridgy]: https://brid.gy/
[Telegraph]: https://telegraph.p3k.io/
