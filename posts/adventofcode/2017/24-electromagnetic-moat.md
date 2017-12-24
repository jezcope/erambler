---
title: "Electromagnetic Moat — Rust — #adventofcode Day 24"
description: "In which I relive my childhood Lego sets."
slug: day-24
date: 2017-12-24T20:11:14+00:00
tags:
- Technology
- Learning
- Advent of Code
- Rust
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/24), the penultimate, requires us to build a bridge capable of reaching across to the CPU, our final destination.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/24-electromagnetic-moat.rs)

!!! commentary
    We have a finite number of components that fit together in a restricted way from which to build a bridge, and we have to work out both the strongest and the longest bridge we can build. The most obvious way to do this is to recursively build every possible bridge and select the best, but that's an `O(n!)` algorithm that could blow up quickly, so might as well go with a nice fast language! Might have to try this in Haskell too, because it's the type of algorithm that lends itself naturally to a pure functional approach.
    
    I feel like I've applied some of the things I've learned in previous challenges I used Rust for, and spent less time mucking about with ownership, and made better use of various language features, including structs and iterators. I'm rather pleased with how my learning of this language is progressing. I'm definitely overusing `Option.unwrap` at the moment though: this is a lazy way to deal with `Option` results and will panic if the result is not what's expected. I'm not sure whether I need to be cloning the components `Vector` either, or whether I could just be passing iterators around.
    
First, we import some bits of standard library and define some data types. The `BridgeResult` struct lets us use the same algorithm for both parts of the challenge and simply change the value used to calculate the maximum.

```rust
use std::io;
use std::fmt;
use std::io::BufRead;

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
struct Component(u8, u8);

#[derive(Debug, Copy, Clone, Default)]
struct BridgeResult {
    strength: u16,
    length: u16,
}

impl Component {
    fn from_str(s: &str) -> Component {
        let parts: Vec<&str> = s.split('/').collect();
        assert!(parts.len() == 2);
        Component(parts[0].parse().unwrap(), parts[1].parse().unwrap())
    }

    fn fits(self, port: u8) -> bool {
        self.0 == port || self.1 == port
    }

    fn other_end(self, port: u8) -> u8 {
        if self.0 == port {
            return self.1;
        } else if self.1 == port {
            return self.0;
        } else {
            panic!("{} doesn't fit port {}", self, port);
        }
    }

    fn strength(self) -> u16 {
        self.0 as u16 + self.1 as u16
    }
}

impl fmt::Display for BridgeResult {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "(S: {}, L: {})", self.strength, self.length)
    }
}
```

`best_bridge` calculates the length and strength of the "best" bridge that can be built from the remaining components and fits the required port. Whether this is based on strength or length is given by the `key` parameter, which is passed to `Iter.max_by_key`.

```rust
fn best_bridge<F>(port: u8, key: &F, components: &Vec<Component>) -> Option<BridgeResult>
    where F: Fn(&BridgeResult) -> u16
{
    if components.len() == 0 {
        return None;
    }
    
    components.iter()
        .filter(|c| c.fits(port))
        .map(|c| {
            let b = best_bridge(c.other_end(port), key,
                                &components.clone().into_iter()
                                .filter(|x| x != c).collect())
                .unwrap_or_default();
             BridgeResult{strength: c.strength() + b.strength,
                          length: 1 + b.length}
        })
        .max_by_key(key)
}
```

Now all that remains is to read the input and calculate the result. I was rather pleasantly surprised to find that in spite of my pessimistic predictions about efficiency, when compiled with optimisations turned on this terminates in less than 1s on my laptop.

```rust
fn main() {
    let stdin = io::stdin();
    let components: Vec<_> = stdin.lock()
        .lines()
        .map(|l| Component::from_str(&l.unwrap()))
        .collect();

    match best_bridge(0, &|b: &BridgeResult| b.strength, &components) {
        Some(b) => println!("Strongest bridge is {}", b),
        None => println!("No strongest bridge found")
    };
    match best_bridge(0, &|b: &BridgeResult| b.length, &components) {
        Some(b) => println!("Longest bridge is {}", b),
        None => println!("No longest bridge found")
    };
}
```
