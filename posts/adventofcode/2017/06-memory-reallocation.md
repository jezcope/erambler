---
title: "Memory Reallocation — Python — #adventofcode Day 6"
description: "In which I relive a programming exercise from my masters course."
slug: day-06
date: 2017-12-09T17:45:46+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/6) asks us to follow a recipe for redistributing objects in memory that bears a striking resemblance to the rules of the African game [Mancala](http://en.wikipedia.org/wiki/Mancala).

!!! commentary
    When I was doing my MSci, one of our programming exercises was to write (in Haskell, IIRC) a program to play a Mancala variant called [Oware](http://en.wikipedia.org/wiki/Oware), so this had a nice ring of nostalgia.
    
    Back to Python today: it's already become clear that it's by far my most fluent language, which makes sense as it's the only one I've used consistently since my schooldays. I'm a bit behind on the blog posts, so you get this one without any explanation, for now at least!

```python
import math


def reallocate(mem):
    max_val = -math.inf
    size = len(mem)
    for i, x in enumerate(mem):
        if x > max_val:
            max_val = x
            max_index = i

    i = max_index
    mem[i] = 0
    remaining = max_val

    while remaining > 0:
        i = (i + 1) % size
        mem[i] += 1
        remaining -= 1

    return mem


def detect_cycle(mem):
    mem = list(mem)
    steps = 0
    prev_states = {}

    while tuple(mem) not in prev_states:
        prev_states[tuple(mem)] = steps
        steps += 1
        mem = reallocate(mem)

    return (steps, steps - prev_states[tuple(mem)])


initial_state = map(int, input().split())

print("Initial state is ", initial_state)
steps, cycle = detect_cycle(initial_state)
print("Steps to cycle: ", steps)
print("Steps in cycle: ", cycle)
```
