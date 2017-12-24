---
title: "Particle Swarm — Python — #adventofcode Day 20"
description: "In which I spray particles everywhere."
slug: day-20
date: 2017-12-24T19:13:51+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/20) finds us simulating the movements of particles in space.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/19-a-series-of-tubes.rs)

!!! commentary
    Back to Python for this one, another relatively straightforward simulation, although it's easier to calculate the answer to part 1 than to simulate.

```python
import fileinput as fi
import numpy as np
import re
```

First we parse the input into 3 2D arrays: using `numpy` enables us to do efficient arithmetic across the whole set of particles in one go.

```python
PARTICLE_RE = re.compile(r'p=<(-?\d+),(-?\d+),(-?\d+)>, '
                         r'v=<(-?\d+),(-?\d+),(-?\d+)>, '
                         r'a=<(-?\d+),(-?\d+),(-?\d+)>')

def parse_input(lines):
    x = []
    v = []
    a = []
    for l in lines:
        m = PARTICLE_RE.match(l)
        x.append([int(x) for x in m.group(1, 2, 3)])
        v.append([int(x) for x in m.group(4, 5, 6)])
        a.append([int(x) for x in m.group(7, 8, 9)])

    return (np.arange(len(x)), np.array(x), np.array(v), np.array(a))

i, x, v, a = parse_input(fi.input())
```

Now we can calculate which particle will be closest to the origin in the long-term: this is simply the particle with the smallest acceleration. It turns out that several have the same acceleration, so of these, the one we want is the one with the lowest starting velocity. This is only complicated slightly by the need to get the *number* of the particle rather than its other information, hence the need to use `numpy.argmin`.

```python
a_abs = np.sum(np.abs(a), axis=1)
a_min = np.min(a_abs)
a_i = np.squeeze(np.argwhere(a_abs == a_min))
closest = i[a_i[np.argmin(np.sum(np.abs(v[a_i]), axis=1))]]
print("Closest: ", closest)
```

Now we define functions to simulate collisions between particles. We have to use the `return_index` and `return_counts` options to `numpy.unique` to be able to get rid of *all* the duplicate positions (the standard usage is to keep one of each duplicate).

```python
def resolve_collisions(x, v, a):
    (_, i, c) = np.unique(x, return_index=True, return_counts=True, axis=0)
    i = i[c == 1]
    return x[i], v[i], a[i]
```

The termination criterion for this loop is an interesting aspect: the most robust to my mind seems to be that eventually the particles will end up sorted in order of their initial acceleration in terms of distance from the origin, so you could check for this but that's pretty computationally expensive. In the end, all that was needed was a bit of trial and error: terminating arbitrarily after 1,000 iterations seems to work! In fact, all the collisions are over after about 40 iterations for my input but there was always the possibility that two particles with very slightly different accelerations would eventually intersect much later.

```python
def simulate_collisions(x, v, a, iterations=1000):
    for _ in range(iterations):
        v += a
        x += v
        x, v, a = resolve_collisions(x, v, a)

    return len(x)

print("Remaining particles: ", simulate_collisions(x, v, a))
```
