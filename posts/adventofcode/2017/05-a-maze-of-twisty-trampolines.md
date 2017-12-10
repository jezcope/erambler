---
title: "A Maze of Twisty Trampolines — C++ — #adventofcode Day 5"
description: "In which I bounce up and down the Standard Template Library."
slug: day-05
date: 2017-12-06T17:49:53+00:00
tags:
- Technology
- Learning
- Advent of Code
- C++
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/5) has us attempting to help the CPU escape from a maze of instructions. It's not quite a [Turing Machine](https://en.wikipedia.org/wiki/Turing%20Machine), but it has that feeling of moving a read/write head up and down a tape acting on and changing the data found there.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/05-a-maze-of-twisty-trampolines.cc)

!!! commentary
    I haven't written anything in C++ for over a decade. It sounds like there have been lots of interesting developments in the language since then, with C++11, C++14 and the freshly finalised C++17 standards (built-in parallelism in the STL!). I won't use any of those, but I thought I'd dust off my C++ and see what happened. Thankfully the Standard Template Library classes still did what I expected!
    
As usual, we first include the parts of the standard library we're going to use: `iostream` for input & output; `vector` for the container. We also declare that we're using the `std` namespace, so that we don't have to prepend `vector` and the other classes with `std::`.

```c++
#include <iostream>
#include <vector>

using namespace std;
```

`steps_to_escape_part1` implements part 1 of the challenge: we read a location, move forward/backward by the number of steps given in that location, then add one to the location before repeating. The result is the number of steps we take before jumping outside the list.

```c++
int steps_to_escape_part1(vector<int>& instructions) {
  int pos = 0, iterations = 0, new_pos;

  while (pos < instructions.size()) {
    new_pos = pos + instructions[pos];
    instructions[pos]++;
    pos = new_pos;
    iterations++;
  }

  return iterations;
}
```

`steps_to_escape_part2` solves part 2, which is very similar, except that an offset greater than 3 is *decremented* instead of incremented before moving on.

```c++
int steps_to_escape_part2(vector<int>& instructions) {
  int pos = 0, iterations = 0, new_pos, offset;

  while (pos < instructions.size()) {
    offset = instructions[pos];
    new_pos = pos + offset;
    instructions[pos] += offset >=3 ? -1 : 1;
    pos = new_pos;
    iterations++;
  }

  return iterations;
}
```

Finally we pull it all together and link it up to the input.

```c++
int main() {
  vector<int> instructions1, instructions2;
  int n;
```

The `cin` class lets us read data from standard input, which we then add to a `vector` of `int`s to give our list of instructions.

```c++
  while (true) {
    cin >> n;
    if (cin.eof())
      break;
    instructions1.push_back(n);
  }
```

Solving the problem modifies the input, so we need to take a copy to solve part 2 as well. Thankfully the STL makes this easy with iterators.

```c++
  instructions2.insert(instructions2.begin(),
                       instructions1.begin(), instructions1.end());
```

Finally, compute the result and print it on standard output.

```c++
  cout << steps_to_escape_part1(instructions1) << endl;
  cout << steps_to_escape_part2(instructions2) << endl;

  return 0;
}
```
