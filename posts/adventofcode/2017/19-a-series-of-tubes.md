---
title: "A Series of Tubes — Rust — #adventofcode Day 19"
description: "In which I give Rust another try."
slug: day-19
date: 2017-12-24T18:15:28+00:00
tags:
- Technology
- Learning
- Advent of Code
- Rust
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/19) asks us to help a network packet find its way.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/19-a-series-of-tubes.rs)

!!! commentary
    Today's challenge was fairly straightforward, following an [ASCII art](http://en.wikipedia.org/wiki/ASCII_art) path, so I thought I'd give Rust another try. I'm a bit behind on the blog posts, so I'm presenting the code below without any further commentary. I'm not really convinced this is good idiomatic Rust, and it was interesting turning a set of strings into a 2D array of characters because there are both `u8` (byte) and `char` types to deal with.

```rust
use std::io;
use std::io::BufRead;

const ALPHA: &'static str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

fn change_direction(dia: &Vec<Vec<u8>>, x: usize, y: usize, dx: &mut i32, dy: &mut i32) {
    assert_eq!(dia[x][y], b'+');
    
    if dx.abs() == 1 {
        *dx = 0;
        if y + 1 < dia[x].len() && (dia[x][y + 1] == b'-' || ALPHA.contains(dia[x][y + 1] as char)) {
            *dy = 1;
        } else if dia[x][y - 1] == b'-' || ALPHA.contains(dia[x][y - 1] as char) {
            *dy = -1;
        } else {
            panic!("Huh? {} {}", dia[x][y+1] as char, dia[x][y-1] as char);
        }
    } else {
        *dy = 0;
        if x + 1 < dia.len() && (dia[x + 1][y] == b'|' || ALPHA.contains(dia[x + 1][y] as char)) {
            *dx = 1;
        } else if dia[x - 1][y] == b'|' || ALPHA.contains(dia[x - 1][y] as char) {
            *dx = -1;
        } else {
            panic!("Huh?");
        }
    }
}

fn follow_route(dia: Vec<Vec<u8>>) -> (String, i32) {
    let mut x: i32 = 0;
    let mut y: i32;
    let mut dx: i32 = 1;
    let mut dy: i32 = 0;
    let mut result = String::new();
    let mut steps = 1;

    match dia[0].iter().position(|x| *x == b'|') {
        Some(i) => y = i as i32,
        None => panic!("Could not find '|' in first row"),
    }

    loop {
        x += dx;
        y += dy;
        match dia[x as usize][y as usize] {
            b'A'...b'Z' => result.push(dia[x as usize][y as usize] as char),
            b'+' => change_direction(&dia, x as usize, y as usize, &mut dx, &mut dy),
            b' ' => return (result, steps),
            _ => (),
        }
        steps += 1;
    }
}

fn main() {
    let stdin = io::stdin();
    let lines: Vec<Vec<u8>> = stdin.lock().lines()
        .map(|l| l.unwrap().into_bytes())
        .collect();

    let result = follow_route(lines);
    println!("Route: {}", result.0);
    println!("Steps: {}", result.1);
}
```
