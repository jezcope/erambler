---
title: "I Heard You Like Registers — Python — #adventofcode Day 8"
description: "In which I implement a very simple assembly-type language."
slug: day-08
date: 2017-12-10T19:33:46+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/8) describes a simple instruction set for a CPU, incrementing and decrementing values in registers according to simple conditions. We have to interpret a stream of these instructions, and to prove that we've done so, give the highest value of any register, both at the end of the program and throughout the whole program.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/08-i-heard-you-like-registers.py)

!!! commentary
    This turned out to be a nice straightforward one to implement, as the instruction format was easily parsed by regular expression, and Python provides the `eval` function which made evaluating the conditions a doddle.

Import various standard library bits that we'll use later.

```python
import re
import fileinput as fi
from math import inf
from collections import defaultdict
```

We could just parse the instructions by splitting the string, but using a regular expression is a little bit more robust because it won't match at all if given an invalid instruction.

```python
INSTRUCTION_RE = re.compile(r'(\w+) (inc|dec) (-?\d+) if (.+)\s*')

def parse_instruction(instruction):
    match = INSTRUCTION_RE.match(instruction)
    return match.group(1, 2, 3, 4)
```

Executing an instruction simply checks the condition and if it evaluates to `True` updates the relevant register.

```python
def exec_instruction(registers, instruction):
    name, op, value, cond = instruction

    value = int(value)
    if op == 'dec':
        value = -value

    if eval(cond, globals(), registers):
        registers[name] += value
```

`highest_value` returns the maximum value found in any register.

```python
def highest_value(registers):
    return sorted(registers.items(), key=lambda x: x[1], reverse=True)[0][1]
```

Finally, loop through all the instructions and carry them out, updating `global_max` as we go. We need to be able to deal with registers that haven't been accessed before. Keeping the registers in a dictionary means that we can evaluate the conditions directly using `eval` above, passing it as the `locals` argument. The standard `dict` will raise an exception if we try to access a key that doesn't exist, so instead we use `collections.defaultdict`, which allows us to specify what the default value for a non-existent key will be. New registers start at 0, so we use a simple lambda to define a function that always returns 0.

```python
global_max = -inf
registers = defaultdict(lambda: 0)
for i in map(parse_instruction, fi.input()):
    exec_instruction(registers, i)
    global_max = max(global_max, highest_value(registers))

print('Max value:', highest_value(registers))
print('All-time max:', global_max)
```


