---
title: "Dueling Generators — Rust — #adventofcode Day 15"
description: "In which I use rust to help generators fight."
slug: day-15
date: 2017-12-15T18:24:09+00:00
tags:
- Technology
- Learning
- Advent of Code
- Rust
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/15) 

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/15-dueling-generators.rs)

!!! commentary
    Ever since I [used Go to solve day 3](../day-3/), I've had a hankering to try the other new kid on the memory-safe compiled language block, [Rust][]. I found it a bit intimidating at first because the syntax wasn't as close to the C/C++ I'm familiar with and there are quite a few concepts unique to Rust, like the use of traits. But I figured it out, so I can tick another language of my to-try list.
    
    I also implemented a [version in Python for comparison][Python version]: the Python version is more concise and easier to read but the Rust version runs about 10× faster.
    
First we include the `std::env` "crate" which will let us get access to commandline arguments, and define some useful constants for later.

```rust
use std::env;

const M: i64 = 2147483647;
const MASK: i64 = 0b1111111111111111;
const FACTOR_A: i64 = 16807;
const FACTOR_B: i64 = 48271;
```

`gen_next` generates the next number for a given generator's sequence. `gen_next_picky` does the same, but for the "picky" generators, only returning values that meet their criteria.

```rust
fn gen_next(factor: i64, current: i64) -> i64 {
    return (current * factor) % M;
}

fn gen_next_picky(factor: i64, current: i64, mult: i64) -> i64 {
    let mut next = gen_next(factor, current);
    while next % mult != 0 {
        next = gen_next(factor, next);
    }
    return next;
}
```

`duel` runs a single duel, and returns the number of times the generators agreed in the lowest 16 bits (found by doing a binary `&` with the mask defined above). Rust allows functions to be passed as parameters, so we use this to be able to run both versions of the duel using only this one function.

```rust
fn duel<F, G>(n: i64, next_a: F, mut value_a: i64, next_b: G, mut value_b: i64) -> i64
where
    F: Fn(i64) -> i64,
    G: Fn(i64) -> i64,
{
    let mut count = 0;

    for _ in 0..n {
        value_a = next_a(value_a);
        value_b = next_b(value_b);
        if (value_a & MASK) == (value_b & MASK) {
            count += 1;
        }
    }

    return count;
}
```

Finally, we read the start values from the command line and run the two duels. The expressions that begin `|n|` are closures (anonymous functions, often called lambdas in other languages) that we use to specify the generator functions for each duel.

```rust
fn main() {
    let args: Vec<String> = env::args().collect();

    let start_a: i64 = args[1].parse().unwrap();
    let start_b: i64 = args[2].parse().unwrap();

    println!(
        "Duel 1: {}",
        duel(
            40000000,
            |n| gen_next(FACTOR_A, n),
            start_a,
            |n| gen_next(FACTOR_B, n),
            start_b,
        )
    );
    println!(
        "Duel 2: {}",
        duel(
            5000000,
            |n| gen_next_picky(FACTOR_A, n, 4),
            start_a,
            |n| gen_next_picky(FACTOR_B, n, 8),
            start_b,
        )
    );
}
```

[Rust]: https://www.rust-lang.org/en-US/

[Python version]: https://github.com/jezcope/aoc2017/blob/master/15-dueling-generators.py
