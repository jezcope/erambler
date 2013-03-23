---
title: OA DOI resolver status update
kind: article
created_at: Wed 20 Mar 21:28:26 2013
categories:
- Things I made
tags:
- DOI
- Open access
- Open scholarship
- OAI-PMH
- Programming
- Open source
---

So, as you'll have seen from my last post, I've been putting together an [alternative DOI resolver that points to open access copies in institutional repositories](http://doi2oa.erambler.co.uk/). I'm enjoying learning some new tools and the challenge of cleaning up some not-quite-ideal data, but if it's to grow into a useful service, it needs several several things:

## A better name

Seriously. "Open Access DOI Resolver" is descriptive but not very distinctive. Sadly, the only name I've come up with so far is "Duh-DOI!" (see the YouTube video below), which doesn't quite convey the right impression.

## A new home

I've grabbed a list of DOI endpoints for British institutional repositories — well over 100. Having tested the code on my iMac, I can confirm it happily harvests DOIs from most [EPrints][]-based repositories. But I've hit 10,000 database rows (the free limit on [Heroku][], the current host) with just the DOIs from a single repository, which means the public version won't be able to resolve anything from outside Bath until the situation changes.

## Better standards compliance

It's a fact of life that everyone implements a standard differently. OAI-PMH and Dublin Core are no exception. Some repositories report both the DOI and the open access URL in `<dc:identifier>` elements; others use `<dc:relation>` for both while using `<dc:identifier>` for something totally different, like the title. Some don't report a URL for the items repository entry at all, only the publisher's (usually paywalled) official URL.

There are efforts under way to improve the situation (like [RIOXX][]), but until then, the best I can do is to implement gradually better heuristics to standardise the diverse data available. To do that, I'm gradually collecting examples of repositories that break my harvesting algorithm and fixing them, but that's a fairly slow process since I'm only working on this in my free time.

[*xkcd: Standards*][Standards]

## Better data

Even with better standards compliance, the tool can only be as good as the available data. I can only resolve a DOI if it's actually been associated with its article in an institutional repository, but not every record that should have a DOI has one. It's possible that a side benefit of this tool is that it will flag up the proportion of IR records that have DOIs assigned.

Then there's the fact that most repository front ends seem not to do any validation on DOIs. As they're entered by humans, there's always going to be scope for error, which there should be some validation in place to at least try and detect. Here are just a few of the "DOIs" from an anonymous sample of British repositories:

-   `+10.1063/1.3247966`
-   `/10.1016/S0921-4526(98)01208-3`
-   `0.1111/j.1467-8322.2006.00410.x`
-   `07510210.1088/0953-8984/21/7/075102`
-   `10.2436 / 20.2500.01.93`
-   `235109 10.1103/PhysRevB.71.235109`
-   `DOI: 10.1109/TSP.2012.2212434`
-   `ShowEdit 10.1074/jbc.274.22.15678`
-   `http://doi.acm.org/10.1145/989863.989893`
-   `http://hdl.handle.net/10.1007/s00191-008-0096-6`
-   `<U+200B>10.<U+200B>1104/<U+200B>pp.<U+200B>111.<U+200B>186957`

In some cases it's clear what the error is and how to correct it programmatically. In other cases any attempt to correct it is guesswork at best and could introduce as many problems as it solves.

That last one is particularly interesting: the `<U+200B>` codes are "zero width spaces". They don't show on screen but are still there to trip up computers trying to read the DOI. I'm not sure how they would get there other than by a deliberate attempt on the part of the publisher to obfuscate the identifier.

It's also only really useful where the repository record we're pointing to actually has the open access full text, rather than just linking to the publisher version, which many do.

## A license

Ok, this one's pretty easy to solve. I'm releasing the code under the [GNU General Public License][GPL]. [It's on github so go fork it][code].

*And here's the video I promised:*

<iframe width="487" height="274" src="http://www.youtube.com/embed/gMiA8AIX03Q" frameborder="0" allowfullscreen></iframe>

[EPrints]: http://eprints.org/
[Heroku]: http://heroku.com/
[RIOXX]: http://www.rioxx.net/about/
[Standards]: http://xkcd.com/927/
[code]: http://github.com/jezcope/doi2oa
[GPL]: http://www.gnu.org/licenses/gpl.html
