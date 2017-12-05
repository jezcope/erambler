---
title: "Corruption Checksum — Python — #adventofcode Day 2"
description: "In which I detect corrupt spreadsheets."
slug: day-02
date: 2017-12-02T09:15:46+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/2) is to calculate a rather contrived "checksum" over a grid of numbers.

[Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/02-corruption-checksum.py)

!!! commentary
    Today I went back to plain Python, and I didn't do formal tests because only one test case was given for each part of the problem. I just got stuck in.
    
    I did write part 2 out in as nested `for` loops as an intermediate step to working out the generator expression. I think that expanded version may have been more readable.
    
    Having got that far, I couldn't then work out how to finally eliminate the need for an auxiliary function entirely without either sorting the same elements multiple times or sorting each row as it's read.

First we read in the input, split it and convert it to numbers. `fileinput.input()` returns an iterator over the lines in all the files passed as command-line arguments, or over standard input if no files are given.

```python
from fileinput import input
sheet = [[int(x) for x in l.split()] for l in input()]
```

Part 1 of the challenge calls for finding the difference between the largest and smallest number in each row, and then summing those differences:

```python
print(sum(max(x) - min(x) for x in sheet))
```

Part 2 is a bit more involved: for each row we have to find the unique pair of elements that divide into each other without remainder, then sum the result of those divisions. We can make it a little easier by sorting each row; then we can take each number in turn and compare it only with the numbers *after* it (which are guaranteed to be larger). Doing this ensures we only make each comparison once.

```python
def rowsum_div(row):
    row = sorted(row)
    return sum(y // x for i, x in enumerate(row) for y in row[i+1:] if y % x == 0)

print(sum(map(rowsum_div, sheet)))
```

We can make this code shorter (if not easier to read) by sorting each row as it's read:

```python
sheet = [sorted(int(x) for x in l.split()) for l in input()]
```

Then we can just use the first and last elements in each row for part 1, as we know those are the smallest and largest respectively in the sorted row:

```python
print(sum(x[-1] - x[0] for x in sheet))
```

Part 2 then becomes a sum over a single generator expression:

```python
print(sum(y // x for row in sheet
          for i, x in enumerate(row)
          for y in row[i+1:]
          if y % x == 0))
```

Very satisfying!
