---
title: "The Halting Problem — Python — #adventofcode Day 25"
description: "In which Turing and I have a little chat about machines."
slug: day-25
date: 2018-01-02T20:47:19+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/25), takes us back to a bit of computing history: a good old-fashioned [Turing Machine](http://en.wikipedia.org/wiki/Turing_Machine).

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/25-the-halting-problem.py)

!!! commentary
    Today's challenge was a nice bit of nostalgia, taking me back to my university days learning about the theory of computing. Turing Machines are a classic bit of computing theory, and are provably able to compute any value that is possible to compute: a value is computable *if and only if* a Turing Machine can be written that computes it (though in practice anything non-trivial is mind-bendingly hard to write as a TM).

A bit of a library-fest today, compared to other days!

```python
from collections import deque, namedtuple
from collections.abc import Iterator
from tqdm import tqdm
import re
import fileinput as fi
```

These regular expressions are used to parse the input that defines the transition table for the machine.

```python
RE_ISTATE = re.compile(r'Begin in state (?P<state>\w+)\.')
RE_RUNTIME = re.compile(
    r'Perform a diagnostic checksum after (?P<steps>\d+) steps.')
RE_STATETRANS = re.compile(
    r"In state (?P<state>\w+):\n"
    r"  If the current value is (?P<read0>\d+):\n"
    r"    - Write the value (?P<write0>\d+)\.\n"
    r"    - Move one slot to the (?P<move0>left|right).\n"
    r"    - Continue with state (?P<next0>\w+).\n"
    r"  If the current value is (?P<read1>\d+):\n"
    r"    - Write the value (?P<write1>\d+)\.\n"
    r"    - Move one slot to the (?P<move1>left|right).\n"
    r"    - Continue with state (?P<next1>\w+).")
MOVE = {'left': -1, 'right': 1}
```

A `namedtuple` to provide some sugar when using a transition rule.

```python
Rule = namedtuple('Rule', 'write move next_state')
```

The `TuringMachine` class does all the work.

```python
class TuringMachine:
    def __init__(self, program=None):
        self.tape = deque()
        self.transition_table = {}
        self.state = None
        self.runtime = 0
        self.steps = 0
        self.pos = 0
        self.offset = 0

        if program is not None:
            self.load(program)

    def __str__(self):
        return f"Current: {self.state}; steps: {self.steps} of {self.runtime}"
```

Some jiggery-pokery to allow us to use `self[pos]` to reference an infinite tape.

```python
    def __getitem__(self, i):
        i += self.offset
        if i < 0 or i >= len(self.tape):
            return 0
        else:
            return self.tape[i]

    def __setitem__(self, i, x):
        i += self.offset
        if i >= 0 and i < len(self.tape):
            self.tape[i] = x
        elif i == -1:
            self.tape.appendleft(x)
            self.offset += 1
        elif i == len(self.tape):
            self.tape.append(x)
        else:
            raise IndexError('Tried to set position off end of tape')
```

Parse the program and set up the transtion table.

```python
    def load(self, program):
        if isinstance(program, Iterator):
            program = ''.join(program)

        match = RE_ISTATE.search(program)
        self.state = match['state']

        match = RE_RUNTIME.search(program)
        self.runtime = int(match['steps'])

        for match in RE_STATETRANS.finditer(program):
            self.transition_table[match['state']] = {
                int(match['read0']): Rule(write=int(match['write0']),
                                          move=MOVE[match['move0']],
                                          next_state=match['next0']),
                int(match['read1']): Rule(write=int(match['write1']),
                                          move=MOVE[match['move1']],
                                          next_state=match['next1']),
            }
```

Run the program for the required number of steps (given by `self.runtime`). `tqdm` isn't in the standard library but it should be: it shows a lovely text-mode progress bar as we go.

```python
    def run(self):
        for _ in tqdm(range(self.runtime),
                      desc="Running", unit="steps", unit_scale=True):
            read = self[self.pos]
            rule = self.transition_table[self.state][read]
            self[self.pos] = rule.write
            self.pos += rule.move
            self.state = rule.next_state
```

Calculate the "diagnostic checksum" required for the answer.

```python
    @property
    def checksum(self):
        return sum(self.tape)
```

Aaand GO!

```python
machine = TuringMachine(fi.input())
machine.run()
print("Checksum:", machine.checksum)
```
