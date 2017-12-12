---
title: "Digital Plumber — Python — #adventofcode Day 12"
description: "In which I try to figure out why people aren't talking to each other."
slug: day-12
date: 2017-12-12T17:43:44+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/12) has us helping a village of programs who are unable to communicate. We have a list of the the communication channels between their houses, and need to sort them out into groups such that we know that each program can communicate with others in its own group but not any others. Then we have to calculate the size of the group containing program 0 and the total number of groups.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/12-digital-plumber.py)

!!! commentary
    This is one of those problems where I'm pretty sure that my algorithm isn't close to being the most efficient, but it definitely works! For the sake of solving the challenge that's all that matters, but it still bugs me.

By now I've become used to using `fileinput` to transparently read data either from files given on the command-line or standard input if no arguments are given.
  
```python
import fileinput as fi
```

First we make an initial pass through the input data, creating a group for each line representing the programs on that line (which can communicate with each other). We store this as a Python `set`.

```python
groups = []
for line in fi.input():
    head, rest = line.split(' <-> ')
    group = set([int(head)])
    group.update([int(x) for x in rest.split(', ')])
    groups.append(group)
```

Now we iterate through the groups, starting with the first, and merging any we find that overlap with our current group.

```python
i = 0
while i < len(groups):
    current = groups[i]
```

Each pass through the groups brings more programs into the current group, so we have to go through and check their connections too. We make several merge passes, until we detect that no more merges took place.

```python
    num_groups = len(groups) + 1
    while num_groups > len(groups):
        j = i+1
        num_groups = len(groups)
```

This inner loop does the actual merging, and deletes each group as it's merged in.

```python
        while j < len(groups):
            if len(current & groups[j]) > 0:
                current.update(groups[j])
                del groups[j]
            else:
                j += 1
    i += 1
```

All that's left to do now is to display the results.

```python
print("Number in group 0:", len([g for g in groups if 0 in g][0]))
print("Number of groups:", len(groups))
```
