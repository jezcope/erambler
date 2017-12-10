---
title: "Knot Hash — Haskell — #adventofcode Day 10"
description: "In which I tie myself in knots for no good reason."
slug: day-10
date: 2017-12-10T21:18:36+00:00
tags:
- Technology
- Learning
- Advent of Code
- Haskell
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/10) asks us to help a group of programs implement a (highly questionable) hashing algorithm that involves repeatedly reversing parts of a list of numbers.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/10-knot-hash.hs)

!!! commentary
    I went with Haskell again today, because it's the weekend so I have a bit more time, and I really enjoyed yesterday's Haskell implementation. Today gave me the opportunity to explore the standard library a bit more, as well as lending itself nicely to being decomposed into smaller parts to be combined using higher-order functions.
    
You know the drill by know: import stuff we'll use later.

```haskell
module Main where

import Data.Char (ord)
import Data.Bits (xor)
import Data.Function ((&))
import Data.List (unfoldr)
import Text.Printf (printf)
import qualified Data.Text as T
```

The worked example uses a concept of the "current position" as a pointer to a location in a static list. In Haskell it makes more sense to instead use the front of the list as the current position, and rotate the whole list as we progress to bring the right element to the front.

```haskell
rotate :: Int -> [Int] -> [Int]
rotate 0 xs = xs
rotate n xs = drop n' xs ++ take n' xs
  where n' = n `mod` length xs
```

The simple version of the hash requires working through the input list, modifying the working list as we go, and incrementing a "skip" counter with each step. Converting this to a functional style, we simply zip up the input with an infinite list `[0, 1, 2, 3, ...]` to give the counter values. Notice that we also have to calculate how far to rotate the working list to get *back* to its original position. `foldl` lets us specify a function that returns a modified version of the working list and feeds the input list in one at a time.

```haskell
simpleKnotHash :: Int -> [Int] -> [Int]
simpleKnotHash size input = foldl step [0..size-1] input' & rotate (negate finalPos)
  where
    input' = zip input [0..]
    finalPos = sum $ zipWith (+) input [0..]
    reversePart xs n  = (reverse $ take n xs) ++ drop n xs
    step xs (n, skip) = reversePart xs n & rotate (n+skip)
```

The full version of the hash (part 2 of the challenge) starts the same way as the simple version, except making 64 passes instead of one: we can do this by using `replicate` to make a list of 64 copies, then collapse that into a single list with `concat`.

```haskell
fullKnotHash :: Int -> [Int] -> [Int]
fullKnotHash size input = simpleKnotHash size input'
  where input' = concat $ replicate 64 input
```

The next step in calculating the full hash collapses the full 256-element "sparse" hash down into 16 elements by XORing groups of 16 together. `unfoldr` is a nice efficient way of doing this.

```haskell
dense :: [Int] -> [Int]
dense = unfoldr dense'
  where
    dense' [] = Nothing
    dense' xs = Just (foldl1 xor $ take 16 xs, drop 16 xs)
```

The final hash step is to convert the list of integers into a hexadecimal string.

```haskell
hexify :: [Int] -> String
hexify = concatMap (printf "%02x")
```

These two utility functions put together building blocks from the `Data.Text` module to parse the input string. Note that no arguments are given: the functions are defined purely by composing other functions using the `.` operator. In Haskell this is referred to as ["point-free" style](https://wiki.haskell.org/Pointfree).

```haskell
strip :: String -> String
strip = T.unpack . T.strip . T.pack

parseInput :: String -> [Int]
parseInput = map (read . T.unpack) . T.splitOn (T.singleton ',') . T.pack
```

Now we can put it all together, including building the weird input for the "full" hash.

```haskell
main = do
  input <- fmap strip getContents
  let simpleInput = parseInput input
      asciiInput = map ord input ++ [17, 31, 73, 47, 23]
      (a:b:_) = simpleKnotHash 256 simpleInput
  print $ (a*b)
  putStrLn $ fullKnotHash 256 asciiInput & dense & hexify
```
