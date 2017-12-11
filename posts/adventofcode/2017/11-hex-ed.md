---
title: "Hex Ed — Python — #adventofcode Day 11"
description: "In which I wander around a hexagonal grid for a while; it's just like playing Civilisation V..."
slug: day-11
date: 2017-12-11T17:15:04+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/11) is to help a program find its child process, which has become lost on a hexagonal grid. We need to follow the path taken by the child (given as input) and calculate the distance it is from home along with the furthest distance it has been at any point along the path.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/11-hex-ed.py)

!!! commentary
    I found this one quite interesting in that it was very quick to solve. In fact, I got lucky and my first quick implementation (`max(abs(l))` below) gave the correct answer in spite of missing an obvious not-so-edge case. Thinking about it, there's only a ⅓ chance that the first incorrect implementation would give the wrong answer!
    
    The code is shorter, so you get more words today. ☺
    
There are a number of different co-ordinate systems on a hexagonal grid (I discovered while reading up after solving it...). I intuitively went for the system known as 'axial' coordinates, where you pick two directions aligned to the grid as your x and y axes: note that these won't be perpendicular. I chose ne/sw as the x axis and se/nw as y, but there are three other possible choices. That leads to the following definition for the directions, encoded as numpy `array`s because that makes some of the code below neater.

```python
import numpy as np

STEPS = {d: np.array(v) for d, v in
         [('ne', (1, 0)), ('se', (0, -1)), ('s', (-1, -1)),
          ('sw', (-1, 0)), ('nw', (0, 1)), ('n', (1, 1))]}
```

`hex_grid_dist`, given a location `l` calculates the number of steps needed to reach that location from the centre at `(0, 0)`. Notice that we can't simply use the [Manhattan distance](http://en.wikipedia.org/wiki/Manhattan_distance) here because, for example, one step north takes us to `(1, 1)`, which would give a Manhattan distance of 2. Instead, we can see that moving in the n/s direction allows us to increment or decrement both coordinates at the same time:

- If the coordinates have the same sign: move n/s until one of them is zero, then move along the relevant ne or se axis back to the origin; in this case the number of steps is greatest of the absolute values of the two coordinates
- If the coordinates have opposite signs: move independently along the ne and se axes to reduce each to 0; this time the number of steps is the *sum* of the absolute values of the two coordinates

```python
def hex_grid_distance(l):
    if sum(np.sign(l)) == 0:  # i.e. opposite signs
        return sum(abs(l))
    else:
        return max(abs(l))
```

Now we can read in the path followed by the child and follow it ourselves, tracking the maximum distance from home along the way.

```python
path = input().strip().split(',')

location = np.array((0, 0))
max_distance = 0

for step in map(STEPS.get, path):
    location += step
    max_distance = max(max_distance, hex_grid_distance(location))

distance = hex_grid_distance(location)

print("Child process is at", location, "which is", distance, "steps away")
print("Greatest distance was", max_distance)
```
