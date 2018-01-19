---
title: "Build documents from code and data with Saga"
description: "In which I finally find my own itch to scratch."
slug: introducing-saga
date: 2018-01-19T21:37:35+00:00
type: post
tags:
- Open source
- Saga
- Python
- Data science
- Reproducibility
---



!!! tldr "TL;DR"
    I've made [Saga, a thing for compiling documents by combining code and data with templates][sagadoc].

[sagadoc]: https://github.com/jezcope/sagadoc

## What is it?

Saga is a very simple command-line tool that reads in one or more data files, runs one or more scripts, then passes the results into a template to produce a final output document. It enables you to maintain a clean separation between data, logic and presentation and produce data-based documents that can easily be updated. That allows the flow of data through the document to be easily understood, a cornerstone of reproducible analysis.

You run it like this:

```sh
saga build -d data.yaml -d other_data.yaml \
  -s analysis.py -t report.md.tmpl \
  -O report.md
```

Any scripts specified with `-s` will have access to the data in local variables, and any changes to local variables in a script will be retained when everything is passed to the template for rendering.

For  debugging, you can also do:

```sh
saga dump -d data.yaml -d other_data.yaml -s analysis.py
```

which will print out the full environment that would be passed to your template with `saga build`.

### Features

Right now this is a really early version. It does the job but I have lots of ideas for features to add if I ever have time. At present it does the following:

- Reads data from one or more YAML files
- Transforms data with one or more Python scripts
- Renders a template in Mako format
- Works with any plain-text output format, including Markdown, LaTeX and HTML

### Use cases

- Write reproducible reports & papers based on machine-readable data
- Separate presentation from content in any document, e.g. your CV (example coming soon)
- *Yours here?*

### Get it!

I haven't released this on [PyPI][] yet, but [all the code is available on GitHub to try out][sagadoc]. If you have [pipenv][] installed (and if you use Python you should!), you can try it out in an isolated virtual environment by doing:

```sh
git clone https://github.com/jezcope/sagadoc.git
cd sagadoc
pipenv install
pipenv run saga
```

or you can set up for development and run some tests:

```sh
pipenv install --dev
pipenv run pytest
```

[PyPI]: https://pypi.org/
[pipenv]: https://docs.pipenv.org/

## Why?

Like a lot of people, I have to produce reports for work, often containing statistics computed from data. Although these generally aren't academic research papers, I see no reason not to aim for a similar level of reproducibility: after all, if I'm telling other people to do it, I'd better take my own advice!

A couple of times now I've done this by writing a template that holds the text of the report and placeholders for values, along with a [Python](https://python.org) script that reads in the data, calculates the statistics I want and completes the template.

This is valuable for two main reasons:

1. If anyone wants to know how I processed the data and calculated those statistics, it's all there: no need to try and remember and reproduce a series of button clicks in Excel;
2. If the data or calculations change, I just need to update the relevant part and run it again, and all the relevant parts of the document will be updated. This is particularly important if changing a single data value requires recalculation of dozens of tables, charts, etc.

It also gives me the potential to factor out and reuse bits of code in the future, add tests and version control everything.

Now that I've done this more than once (and it seems likely I'll do it again) it makes sense to package that script up in a more portable form so I don't have to write it over and over again (or, shock horror, copy & paste it!). It saves time, and gives others the possibility to make use of it.

### Prior art

I'm not the first person to think of this, but I couldn't find anything that did exactly what I needed.

Several tools will let you interweave code and prose, including the results of evaluating each code snippet in the document: chief among these are [Jupyter][] and [Rmarkdown][].

There are also tools that let you write code in the order that makes most sense to read and then rearrange it into the right order to execute, so-call literate programming. The original tool for this is the venerable [noweb][].

Sadly there is very little that combine both of these and allow you to insert the results of various calculations at arbitrary points in a document, independent of the order of either presenting or executing the code. The only two that I'm aware of are: [Dexy][] and [org-mode][]. Unfortunately, Dexy currently only works on Legacy Python (/Python 2) and org-mode requires emacs (which is fine but not exactly portable). [Rmarkdown][] comes close and supports a range of languages but the full feature set is only available with R.

[Jupyter]: https://jupyter.org/
[Rmarkdown]: https://rmarkdown.rstudio.com/
[noweb]: https://en.wikipedia.org/wiki/Noweb
[Dexy]: http://dexy.it
[org-mode]: https://orgmode.org/

Actually, my ideal solution is org-mode without the emacs dependency, because that's the most flexible solution; maybe one day I'll have both the time and skill to implement that. It's also possible I might be able to figure out Dexy's internals to add what I want to it, but until then Saga does the job!

## Future work

There are lots of features that I'd still like to add when I have time:

- Some actual documentation! And examples!
- More data formats (e.g. CSV, JSON, TOML)
- More languages (e.g. R, Julia)
- Fetching remote data over http
- Caching of intermediate results to speed up rebuilds

For now, though, I'd love for you [to try it out][sagadoc] and let me know what you think! As ever, comment here, tweet me or start an issue on GitHub.
