---
title: "Inverse Captcha — Coconut — #adventofcode Day 1"
description: "In which I try to prove I am not human."
slug: day-01
date: 2017-12-01T14:35:40+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
- Coconut
series: aoc2017
---

Well, December's here at last, and with it [Day 1 of Advent of Code](http://adventofcode.com/2017/day/1).

> … It goes on to explain that you may only leave by solving a captcha to prove you're not a human. Apparently, you only get one millisecond to solve the captcha: too fast for a normal human, but it feels like hours to you. …

As well as posting solutions here when I can, I'll be putting them all on <https://github.com/jezcope/aoc2017> too.

!!! commentary
    After doing some challenges from last year in [Haskell][] for a warm up, I felt inspired to try out the functional-ish Python dialect, [Coconut][]. Now that I've done it, it feels a bit of an odd language, [neither fish nor fowl][]. It'll look familiar to any Pythonista, but is loaded with features normally associated with functional languages, like pattern matching, destructuring assignment, partial application and function composition.
    
    That makes it quite fun to work with, as it works similarly to Haskell, but because it's restricted by the basic rules of Python syntax everything feels a bit more like hard work than it should.
    
    The accumulator approach feels clunky, but it's necessary to allow [tail call elimination](https://en.wikipedia.org/wiki/Tail_call), which Coconut will do and I wanted to see in action. Lo and behold, if you take a look at the [compiled Python version](https://github.com/jezcope/aoc2017/blob/86c8100824bda1b35e5db6e02d4b80890be7a022/01-inverse-captcha.py#L675) you'll see that my recursive implementation has been turned into a non-recursive `while` loop.
    
    Then again, maybe I'm just jealous of Phil Tooley's [one-liner solution in Python](https://github.com/ptooley/aocGolf/blob/1380d78194f1258748ccfc18880cfd575baf5d37/2017.py#L8).

[Haskell]: https://www.haskell.org
[Coconut]: http://coconut-lang.org
[neither fish nor fowl]: https://en.wiktionary.org/wiki/neither_fish_nor_fowl

```coconut
import sys

def inverse_captcha_(s, acc=0):
    case reiterable(s):
        match (|d, d|) :: rest:
            return inverse_captcha_((|d|) :: rest, acc + int(d))
        match (|d0, d1|) :: rest:
            return inverse_captcha_((|d1|) :: rest, acc)

    return acc


def inverse_captcha(s) = inverse_captcha_(s :: s[0])


def inverse_captcha_1_(s0, s1, acc=0):
    case (reiterable(s0), reiterable(s1)):
        match ((|d0|) :: rest0, (|d0|) :: rest1):
            return inverse_captcha_1_(rest0, rest1, acc + int(d0))
        match ((|d0|) :: rest0, (|d1|) :: rest1):
            return inverse_captcha_1_(rest0, rest1, acc)

    return acc


def inverse_captcha_1(s) = inverse_captcha_1_(s, s$[len(s)//2:] :: s)


def test_inverse_captcha():
    assert "1111" |> inverse_captcha == 4
    assert "1122" |> inverse_captcha == 3
    assert "1234" |> inverse_captcha == 0
    assert "91212129" |> inverse_captcha == 9


def test_inverse_captcha_1():
    assert "1212" |> inverse_captcha_1 == 6
    assert "1221" |> inverse_captcha_1 == 0
    assert "123425" |> inverse_captcha_1 == 4
    assert "123123" |> inverse_captcha_1 == 12
    assert "12131415" |> inverse_captcha_1 == 4

if __name__ == "__main__":
    sys.argv[1] |> inverse_captcha |> print
    sys.argv[1] |> inverse_captcha_1 |> print
```
