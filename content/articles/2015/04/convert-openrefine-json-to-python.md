---
title: "Converting OpenRefine JSON to Python code"
kind: article
created_at: Wed 15 Apr 2015 20:38:19 BST
categories:
- Ideas
tags:
- Python
- OpenRefine
- Data
- Data wrangling
---

[OpenRefine][] has a pretty cool feature.  You can export a project's entire edit history in <%= link_wikipedia("JSON") %> format, and subsequently paste it back to exactly repeat what you did.  This is great for transparency: if someone asks what you did in cleaning up your data, you can tell them exactly instead of giving them a vague, general description of what you think you remember you did.  It also means that if you get a new, slightly-updated version of the raw data, you can clean it up in exactly the same way very quickly.

```javascript
[
  {
    "op": "core/column-rename",
    "description": "Rename column Column to Funder",
    "oldColumnName": "Column",
    "newColumnName": "Funder"
  },
  {
    "op": "core/row-removal",
    "description": "Remove rows",
    "engineConfig": {
      "mode": "row-based",
// etc…
```

Now this is great, but it could be better.  I've been playing with [Python][] for data wrangling, and it would be amazing if you could load up an OpenRefine history script in Python and execute it over an arbitrary dataset.  You'd be able to reproduce the analysis without having to load up a whole Java stack and muck around with a web browser, and you could integrate it much more tightly with any pre- or post-processing.

Going a stage further, it would be even better to be able to convert the OpenRefine history JSON to an actual Python script.  That would be a great learning tool for anyone wanting to go from OpenRefine to writing their own code.

```python
import pandas as pd

data = pd.read_csv("funder_info.csv")
data = data.rename(columns = {"Column": "Funder"})
data = data.drop(data.index[6:9])
```

This seems like it could be fairly straightforward to implement: it just requires a bit of digging to understand the semantics of the JSON thot OpenRefine produces, and then the implementation of each operation in Python.  The latter part shouldn't be much of a stretch with so many existing tools like [pandas][].

It's just an idea right now, but I'd be willing to have a crack at implementing something if there was any interest — let me know in the comments or [on Twitter][jezcope] if you think it's worth doing, or if you fancy contributing.

[pandas]: http://pandas.pydata.org/

[OpenRefine]: http://openrefine.org/

[Python]: http://python.org/

[jezcope]: https://twitter.com/jezcope "Twitter: @jezcope"

{::comment}
Local Variables:
mode: gfm
End:
{:/comment}
