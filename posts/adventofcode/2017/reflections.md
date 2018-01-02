---
title: "Reflections on #aoc2017"
description: "In which I look back on 25 days of regular coding."
slug: reflections
date: 2018-01-02T21:02:37+00:00
type: post
tags:
- Technology
- Learning
- Advent of Code
- Reflection
series: aoc2017
---


{{% figure alt="Trees reflected in a lake"
src="/images/posts/2018-01-02-reflection.jpg"
caption="Trees reflected in a lake"
attr="Joshua Reddekopp on Unsplash"
attrlink="https://unsplash.com/photos/-3uIUqsR-Rw"
class="main-illustration fr" %}}

It seems like ages ago, but [way back in November](../advent-of-code-2017/) I committed to completing [Advent of Code](https://adventofcode.com). I managed it all, and it was fun!

All of my code is [available on GitHub](https://jezcope/aoc2017) if you’re interested in seeing what I did, and I managed to get out a blog post for every one with a bit more commentary, which you can see in the series list above.

## How did I approach it?

I’ve not really done any serious programming challenges before. I don’t get to write a lot of code at the moment, so all I wanted from AoC was an excuse to do some proper problem-solving.

I never really intended to take a polyglot approach, though I did think that I might use mainly Python with a bit of Haskell. In the end, though, I used: Python (×12); Haskell (×7); Rust (×4); Go; C++; Ruby; Julia; and Coconut.

For the most part, my priorities were getting the right answer, followed by writing readable code. I didn’t specifically focus on performance but did try to avoid falling into traps that I knew about.

## What did I learn?

I found Python the easiest to get on with: it’s the language I know best and although I can’t always remember exact method names and parameters I know what’s available and where to look to remind myself, as well as most of the common idioms and some performance traps to avoid. Python was therefore the language that let me focus most on solving the problem itself. C++ and Ruby were more challenging, and it was harder to write good idiomatic code but I can still remember quite a lot.

Haskell I haven’t used since university, and just like back then I really enjoyed working out how to solve problems in a functional style while still being readable and efficient (not always something I achieved...). I learned a lot about core Haskell concepts like monads & functors, and I’m really amazed by the way the Haskell community and ecosystem has grown up in the last decade.

I also wanted to learn at least one modern, memory-safe compiled language, so I tried both Go and Rust. Both seem like useful languages, but Rust really intrigued me with its conceptual similarities to both Haskell and C++ and its promise of memory safety without a garbage collector. I struggled a lot initially with the “borrow checker” (the component that enforces memory safety at compile time) but eventually started thinking in terms of ownership and lifetimes after which things became easier. The Rust community seems really vibrant and friendly too.

## What next?

I really want to keep this up, so I’m going to look out some more programming challenges ([Project Euler](https://projecteuler.net/) looks interesting). It turns out there’s a regular Code Dojo meetup in Leeds, so hopefully I’ll try that out too. I’d like to do more realistic data-science stuff, so I’ll be taking a closer look at stuff like [Kaggle](https://kaggle.com/) too, and figuring out how to do a bit more analysis at work.

I’m also feeling motivated to find an open source project to contribute to and/or release a project of my own, so we’ll see if that goes anywhere! I’ve always found the advice to “scratch your own itch” difficult to follow because everything I think of myself has already been done better. Most of the projects I use enough to want to contribute to tend to be pretty well developed with big communities and any bugs that might be accessible to me will be picked off and fixed before I have a chance to get started. Maybe it’s time to get over myself and just reimplement something that already exists, just for the fun of it!
