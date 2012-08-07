---
title: "Scraping for gold at the Olympics"
kind: article
created_at: Tue  7 Aug 20:59:16 2012
categories:
- Coding
tags:
- Olympics
- London 2012
- Medals
- Open data
- Ruby
- Screen scraping
---

What if it wasn't all about the gold medals? The Olympic medal table is always ranked in order of gold medals first, then silver, then bronze.

That seems reasonable, but if you looked at the table at the end of 6 August, for example, you'd have seen that Germany had an impressive 22 medals, including 5 golds, but ranked one place behind Kazakhstan, who had only 7 medals, but 6 of which were gold.

So I thought it was time to do a few things I've wanted to try for a while: scrape some publicly available data, do something interesting with it, and write and deploy a Ruby webapp beyond my desktop.

## Finding the data

It just so happens that the [BBC's medal table][] is marked up with some nice semantic attributes:

* Each `<tr>` tag has two attributes: `data-country-name` and `data-country-code`;
* Each `<td>` tag uses the class `gold`, `silver` or `bronze` and contains *only* the number of medals of that type for that country.

[BBC's medal table]: http://www.bbc.co.uk/sport/olympics/2012/medals/countries

## Just scraping by

I could have just scraped that data from within the webapp, but I wanted a) to have a bit more robustness if the source page changed format or disappeared; and b) to make the data easily available to others.

So I wrote this [London 2012 medal table scraper][] in [ScraperWiki][]. ScraperWiki lets you write scrapers in Ruby, Python or PHP using their API and some standard parsing modules to scrape data and store it in an SQLite table. The data is then available as JSON via a REST API, and remains so even if the source page vanishes (it just sends you a notification so you can fix your scraper).

[London 2012 medal table scraper]: https://scraperwiki.com/scrapers/london_2012_medal_table/
[ScraperWiki]: http://scraperwiki.com/

## Let's go Camping

I briefly thought about using [Ruby on Rails][], but that's a pretty heavy solution to a very small problem, so instead I turned to [Camping][], a "web framework which consistently stays at less than 4kB of code."

Camping is very [MVC][]-based, but your whole app can live in a single file, like a simple CGI script.

[Ruby on Rails]: http://rubyonrails.org/
[Camping]: http://camping.rubyforge.org/
[MVC]: http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller

## Putting it all together

So, [here's my alternative Olympic medal table app][app], and [here's the code on GitHub][code].

What are the effects? Well, if you sort by total medals, there's quite a big shake up. Russia with 41 medals (only 7 gold) shoot up from 6th to 3rd place, pushing Britain down to 4th. North Korea, on the other hand, drop down from 8th to 24th.

Using a weighted sum of the medals (with a gold worth 3 points, silver 2 and bronze 1) yields a similar but less dramatic upheaval, with Russia still up and North Korea still down, but GB restored to 3rd place.

Can you think of a different way to sort the medals? [Stick a feature request on the GitHub tracker][tracker], or fork it and have a go yourself.

[app]: http://altmedals2012.herokuapp.com/
[code]: http://github.com/jezcope/altmedals2012
[tracker]: https://github.com/jezcope/altmedals2012/issues/new
