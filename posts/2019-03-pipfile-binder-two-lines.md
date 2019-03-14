---
title: "Using Pipfile in Binder"
description: "In which I capture a reproducible environment with just 2 lines of code"
slug: pipfile-binder-two-lines
date: 2019-03-14T20:08:17+00:00
type: post
tags:
- Technology
- Reproducibility
- Open research
- Python
---

{{% figure alt="A nice binder tied up with ribbon"
src="/images/posts/2019-03-binder.jpg"
attr="Photo by Sear Greyson on Unsplash"
attrlink="https://unsplash.com/photos/K-ZsC7YdJ6Y?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
class="main-illustration fw" %}}

I recently attended a workshop, organised by the excellent team of the [Turing Way project][], on a tool called BinderHub. BinderHub, along with public hosting platform [MyBinder][], allows you to publish computational notebooks online as "binders" such that they're not static but fully interactive. It's able to do this by using a tool called repo2docker to capture the full computational environment and dependencies required to run the notebook.

!!! aside "What is the Turing Way?"
    The Turing Way is, in its own words, "a lightly opinionated guide to reproducible data science." The team is building an open textbook and running a number of workshops for scientists and research software engineers, and you should [check out the project on Github][Turing Way project]. You could even contribute!

The Binder process goes roughly like this:

1. Do some work in a [Jupyter Notebook][] or similar
2. Put it into a public git repository
3. Add some extra metadata describing the packages and versions your code relies on
4. Go to [mybinder.org][MyBinder] and tell it where to find your repository
5. Open the URL it generates for you
6. Profit

Other than step 5, which can take some time to build the binder, this is a remarkably quick process. It supports a number of different languages too, including built-in support for R, Python and Julia and the ability to configure pretty much any other language that will run on Linux.

However, the Python support currently requires you to have either a `requirements.txt` or Conda-style `environment.yml` file to specify dependencies, and I commonly use a [`Pipfile`][Pipfile] for this instead. `Pipfile` allows you to specify a loose range of compatible versions for maximal convenience, but then locks in specific versions for maximal reproducibility. You can upgrade packages any time you want, but you're fully in control of when that happens, and the locked versions are checked into version control so that everyone working on a project gets consistency.

Since `Pipfile` is emerging as something of a standard thought I'd see if I could use that in a binder, and it turns out to be remarkably simple. The reference implementation of `Pipfile` is a tool called [`pipenv`][pipenv] by the prolific [Kenneth Reitz][]. All you need to use this in your binder is two files of one line each.

`requirements.txt` tells repo2binder to build a Python-based binder, and contains a single line to install the pipenv package:

```
pipenv
```

Then `postBuild` is used by repo2binder to install all other dependencies using pipenv:

```shell
pipenv install --system
```

The ```--system``` flag tells pipenv to install packages globally (its default behaviour is to create a Python virtualenv).

With these two files, the binder builds and runs as expected. You can [see a complete example that I put together during the workshop here on Gitlab][binder example].

[binder example]: https://gitlab.com/jezcope/runkeeper-data
[MyBinder]: https://mybinder.org/
[Pipfile]: https://github.com/pypa/pipfile
[pipenv]: https://pipenv.readthedocs.io/en/latest/
[Kenneth Reitz]: http://kennethreitz.org/
[Turing Way project]: https://github.com/alan-turing-institute/the-turing-way
[Jupyter Notebook]: /blog/jupyter-notebooks-introduction/
