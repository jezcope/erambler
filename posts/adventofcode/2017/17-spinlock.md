---
title: "Spinlock — Rust/Python — #adventofcode Day 17"
description: "In which I decide that one language just isn't enough."
slug: day-17
date: 2017-12-17T20:03:38+00:00
tags:
- Technology
- Learning
- Advent of Code
- Rust
- Python
series: aoc2017
---

In [today's challenge](http://adventofcode.com/2017/day/17) we deal with a monstrous whirlwind of a program, eating up CPU and memory in equal measure.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/17-spinlock.rs) ([and Python driver script](https://github.com/jezcope/aoc2017/blob/master/17-spinlock.py))

!!! commentary
    One of the things I wanted from AoC was an opportunity to try out some popular languages that I don't currently know, including the memory-safe, strongly-typed compiled languages Go and Rust. Realistically though, I'm likely to continue doing most of my programming in Python, and use one of these other languages when it has better tools or I need the extra speed.

    In which case, what I really want to know is how I can call functions written in Go or Rust from Python. I thought I'd try Rust first, as it seems to be designed to be C-compatible and that makes it easy to call from Python using [`ctypes`](https://docs.python.org/3.6/library/ctypes.html).

    Part 1 was another straightforward simulation: translate what the "spinlock" monster is doing into code and run it. It was pretty obvious from the story of this challenge and experience of the last few days that this was going to be another one where the simulation is too computationally expensive for part two, which turns out to be correct.

So, first thing to do is to implement the meat of the solution in Rust. `spinlock` solves the first part of the problem by doing exactly what the monster does. Since we only have to go up to 2017 iterations, this is very tractable. The last number we insert is 2017, so we just return the number immediately after that.

```rust
#[no_mangle]
pub extern fn spinlock(n: usize, skip: usize) -> i32 {
    let mut buffer: Vec<i32> = Vec::with_capacity(n+1);
    buffer.push(0);
    buffer.push(1);
    let mut pos = 1;

    for i in 2..n+1 {
        pos = (pos + skip + 1) % buffer.len();
        buffer.insert(pos, i as i32);
    }

    pos = (pos + 1) % buffer.len();

    return buffer[pos];
}
```

For the second part, we have to do 50 *million* iterations instead, which is a lot. Given that every time you insert an item in the list it has to move up all the elements after that position, I'm pretty sure the algorithm is `O(n^2)`, so it's going to take a lot longer than 10,000ish times the first part.

Thankfully, we don't need to build the whole list, just keep track of where 0 is and what number is immediately after it. There may be a closed-form solution to simply calculate the result, but I couldn't think of it and this is good enough.

```rust
#[no_mangle]
pub extern fn spinlock0(n: usize, skip: usize) -> i32 {
    let mut pos = 1;
    let mut pos_0 = 0;
    let mut after_0 = 1;

    for i in 2..n+1 {
        pos = (pos + skip + 1) % i;
        if pos == pos_0 + 1 {
            after_0 = i;
        }
        if pos <= pos_0 {
            pos_0 += 1;
        }
    }

    return after_0 as i31;
}
```

Now it's time to call this code from Python. Notice the `#[no_mangle]` pragmas and `pub extern` declarations for each function above, which are required to make sure the functions are exported in a C-compatible way. We can build this into a shared library like this:

```shell
rustc --crate-type=cdylib -o spinlock.so 17-spinlock.rs
```

The Python script is as simple as loading this library, reading the puzzle input from the command line and calling the functions. The `ctypes` module does a lot of magic so that we don't have to worry about converting from Python types to native types and back again.

```python
import ctypes
import sys

lib = ctypes.cdll.LoadLibrary("./spinlock.so")

skip = int(sys.argv[1])
print("Part 1:", lib.spinlock(2017, skip))
print("Part 2:", lib.spinlock0(50_000_000, skip))
```

This is a toy example as far as calling Rust from Python is concerned, but it's worth noting that already we can play with the parameters to the two Rust functions without having to recompile. For more serious work, I'd probably be looking at something like [PyO3](https://github.com/PyO3/pyo3) to make a proper Python module. Looks like there's also a [very early Rust numpy integration](https://github.com/termoshtt/rust-numpy) for integrating numerical stuff.

You can also do the same thing from Julia, which has a `ccall` function built in:

```julia
ccall((:spinlock, "./spinlock.so"), Int32, (UInt64, UInt64), 2017, 377)
```

My next thing to try might be [Haskell → Python](https://wiki.python.org/moin/PythonVsHaskell#Using_both_Python_.26_Haskell_with_ctypes_.28-.3B) though…
