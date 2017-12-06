---
title: "Advent of Code 2017: introduction"
description: "In which I plan to take part in the annual daily coding challenge for the month of December."
slug: advent-of-code-2017
date: 2017-11-29T18:33:08+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
- Haskell
- Emacs
series: aoc2017
---

It's a common lament of mine that I don't get to write a lot of code in my day-to-day job. I like the feeling of making something from nothing, and I often look for excuses to write bits of code, both at work and outside it.

[Advent of Code][] is a daily series of programming challenges for the month of December, and is about to start its third annual incarnation. I discovered it too late to take part in any serious way last year, but I'm going to give it a try this year.

[Advent of Code]: http://adventofcode.com

There are no restrictions on programming language (so of course some people delight in using esoteric languages like [Brainf**k](https://en.wikipedia.org/wiki/Brainfuck)), but I think I'll probably stick with Python for the most part. That said, I miss my Haskell days and I'm intrigued by new kids on the block Go and Rust, so I might end up throwing in a few of those on some of the simpler challenges.

I'd like to focus a bit more on *how* I solve the puzzles. They generally come in two parts, with the second part only being revealed after successful completion of the first part. With that in mind, test-driven development makes a lot of sense, because I can verify that I haven't broken the solution to the first part in modifying to solve the second.

I may also take a literate programming approach with `org-mode` or Jupyter notebooks to document my solutions a bit more, and of course that will make it easier to publish solutions here so I'll do that as much as I can make time for.

---

On that note, here are some solutions for 2016 that I've done recently as a warmup.

## Day 1: Python

[Day 1 instructions](http://adventofcode.com/2016/day/1)

```python
import numpy as np
import pytest as t
import sys

TURN = {
    'L': np.array([[0,  1],
                   [-1, 0]]),
    'R': np.array([[0, -1],
                   [1,  0]])
}
ORIGIN = np.array([0, 0])
NORTH = np.array([0, 1])


class Santa:
    def __init__(self, location, heading):
        self.location = np.array(location)
        self.heading = np.array(heading)
        self.visited = [(0,0)]

    def execute_one(self, instruction):
        start_loc = self.location.copy()
        self.heading = self.heading @ TURN[instruction[0]]
        self.location += self.heading * int(instruction[1:])
        self.mark(start_loc, self.location)

    def execute_many(self, instructions):
        for i in instructions.split(','):
            self.execute_one(i.strip())

    def distance_from_start(self):
        return sum(abs(self.location))

    def mark(self, start, end):
        for x in range(min(start[0], end[0]), max(start[0], end[0])+1):
            for y in range(min(start[1], end[1]), max(start[1], end[1])+1):
                if any((x, y) != start):
                    self.visited.append((x, y))

    def find_first_crossing(self):
        for i in range(1, len(self.visited)):
            for j in range(i):
                if self.visited[i] == self.visited[j]:
                    return self.visited[i]

    def distance_to_first_crossing(self):
        crossing = self.find_first_crossing()
        if crossing is not None:
            return abs(crossing[0]) + abs(crossing[1])

    def __str__(self):
        return f'Santa @ {self.location}, heading {self.heading}'


def test_execute_one():
    s = Santa(ORIGIN, NORTH)

    s.execute_one('L1')
    assert all(s.location == np.array([-1, 0]))
    assert all(s.heading == np.array([-1, 0]))

    s.execute_one('L3')
    assert all(s.location == np.array([-1, -3]))
    assert all(s.heading == np.array([0, -1]))

    s.execute_one('R3')
    assert all(s.location == np.array([-4, -3]))
    assert all(s.heading == np.array([-1, 0]))

    s.execute_one('R100')
    assert all(s.location == np.array([-4, 97]))
    assert all(s.heading == np.array([0, 1]))


def test_execute_many():
    s = Santa(ORIGIN, NORTH)

    s.execute_many('L1, L3, R3')
    assert all(s.location == np.array([-4, -3]))
    assert all(s.heading == np.array([-1, 0]))

def test_distance():
    assert Santa(ORIGIN, NORTH).distance_from_start() == 0
    assert Santa((10, 10), NORTH).distance_from_start() == 20
    assert Santa((-17, 10), NORTH).distance_from_start() == 27


def test_turn_left():
    east = NORTH @ TURN['L']
    south = east @ TURN['L']
    west = south @ TURN['L']

    assert all(east == np.array([-1, 0]))
    assert all(south == np.array([0, -1]))
    assert all(west == np.array([1, 0]))


def test_turn_right():
    west = NORTH @ TURN['R']
    south = west @ TURN['R']
    east = south @ TURN['R']

    assert all(east == np.array([-1, 0]))
    assert all(south == np.array([0, -1]))
    assert all(west == np.array([1, 0]))


if __name__ == '__main__':
    instructions = sys.stdin.read()

    santa = Santa(ORIGIN, NORTH)
    santa.execute_many(instructions)

    print(santa)
    print('Distance from start:', santa.distance_from_start())
    print('Distance to target: ', santa.distance_to_first_crossing())
```

## Day 2: Haskell

[Day 2 instructions](http://adventofcode.com/2016/day/2)

```haskell
module Main where

data Pos = Pos Int Int deriving (Show)

-- Magrittr-style pipe operator
(|>) :: a -> (a -> b) -> b
x |> f = f x

swapPos :: Pos -> Pos
swapPos (Pos x y) = Pos y x

clamp :: Int -> Int -> Int -> Int
clamp lower upper x | x < lower = lower
                    | x > upper = upper
                    | otherwise = x

clampH :: Pos -> Pos
clampH (Pos x y) = Pos x' y'
  where y' = clamp 0 4 y
        r = abs (2 - y')
        x' = clamp r (4-r) x

clampV :: Pos -> Pos
clampV = swapPos . clampH . swapPos
                        
buttonForPos :: Pos -> String
buttonForPos (Pos x y) = [buttons !! y !! x]
  where buttons = ["  D  ",
                   " ABC ",
                   "56789",
                   " 234 ",
                   "  1  "]

decodeChar :: Pos -> Char -> Pos
decodeChar (Pos x y) 'R' = clampH $ Pos (x+1) y
decodeChar (Pos x y) 'L' = clampH $ Pos (x-1) y
decodeChar (Pos x y) 'U' = clampV $ Pos x (y+1)
decodeChar (Pos x y) 'D' = clampV $ Pos x (y-1)

decodeLine :: Pos -> String -> Pos
decodeLine p "" = p
decodeLine p (c:cs) = decodeLine (decodeChar p c) cs

makeCode :: String -> String
makeCode instructions = lines instructions          -- split into lines
                        |> scanl decodeLine (Pos 1 1) -- decode to positions
                        |> tail                       -- drop start position
                        |> concatMap buttonForPos     -- convert to buttons

main = do
  input <- getContents
  putStrLn $ makeCode input
```
