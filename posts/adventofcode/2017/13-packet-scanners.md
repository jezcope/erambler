---
title: "Packet Scanners — Haskell — #adventofcode Day 13"
description: "In which I get the job done."
slug: day-13
date: 2017-12-15T15:56:20+00:00
tags:
- Technology
- Learning
- Advent of Code
- Haskell
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/13) requires us to sneak past a firewall made up of a series of scanners.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/13-packet-scanners-redux.hs)

!!! commentary
    I wasn't really thinking straight when I solved this challenge. I got a solution without too much trouble, but I ended up simulating the step-by-step movement of the scanners.
    
    I finally realised that I could calculate whether or not a given scanner was safe at a given time directly with modular arithmetic, and it bugged me so much that I reimplemented the solution. Both are given below, the faster one first.

First we introduce some standard library stuff and define some useful utilities.
    
```haskell
module Main where

import qualified Data.Text as T
import Data.Maybe (mapMaybe)

strip :: String -> String
strip = T.unpack . T.strip . T.pack

splitOn :: String -> String -> [String]
splitOn sep = map T.unpack . T.splitOn (T.pack sep) . T.pack

parseScanner :: String -> (Int, Int)
parseScanner s = (d, r)
  where [d, r] = map read $ splitOn ": " s
```

`traverseFW` does all the hard work: it checks for each scanner whether or not it's safe as we pass through, and returns a list of the severities of each time we're caught. `mapMaybe` is like the standard `map` in many languages, but operates on a list of Haskell `Maybe` values, like a combined `map` and `filter`. If the value is `Just x`, `x` gets included in the returned list; if the value is `Nothing`, then it gets thrown away.

```haskell
traverseFW :: Int -> [(Int, Int)] -> [Int]
traverseFW delay = mapMaybe caught
  where
    caught (d, r) = if (d + delay) `mod` (2*(r-1)) == 0
      then Just (d * r)
      else Nothing
```

Then the total severity of our passage through the firewall is simply the sum of each individual severity.

```haskell
severity :: [(Int, Int)] -> Int
severity = sum . traverseFW 0
```

But we don't want to know how badly we got caught, we want to know how long to wait before setting off to get through safely. `findDelay` tries traversing the firewall with increasing delay, and returns the delay for the first pass where we predict not getting caught.

```haskell
findDelay :: [(Int, Int)] -> Int
findDelay scanners = head $ filter (null . flip traverseFW scanners) [0..]
```

And finally, we put it all together and calculate and print the result.

```haskell
main = do
  scanners <- fmap (map parseScanner . lines) getContents

  putStrLn $ "Severity: " ++ (show $ severity scanners)
  putStrLn $ "Delay: " ++ (show $ findDelay scanners)
```

I'm not generally bothered about performance for these challenges, but here I'll note that my second attempt runs in a little under 2 seconds on my laptop:

```
$ time ./13-packet-scanners-redux < 13-input.txt
Severity: 1900
Delay: 3966414
./13-packet-scanners-redux < 13-input.txt  1.73s user 0.02s system 99% cpu 1.754 total
```

Compare that with the first, simulation-based one, which takes nearly a full minute:

```
$ time ./13-packet-scanners < 13-input.txt
Severity: 1900
Delay: 3966414
./13-packet-scanners < 13-input.txt  57.63s user 0.27s system 100% cpu 57.902 total
```

And for good measure, here's the code. Notice the `tick` and `tickOne` functions, which together simulate moving all the scanners by one step; for this to work we have to track the full current state of each scanner, which is easier to read with a Haskell record-based custom data type. `traverseFW` is more complicated because it has to drive the simulation, but the rest of the code is mostly the same.

```haskell
module Main where

import qualified Data.Text as T
import Control.Monad (forM_)

data Scanner = Scanner { depth :: Int
                       , range :: Int
                       , pos :: Int
                       , dir :: Int }
instance Show Scanner where
  show (Scanner d r p dir) = show d ++ "/" ++ show r ++ "/" ++ show p ++ "/" ++ show dir

strip :: String -> String
strip = T.unpack . T.strip . T.pack

splitOn :: String -> String -> [String]
splitOn sep str = map T.unpack $ T.splitOn (T.pack sep) $ T.pack str

parseScanner :: String -> Scanner
parseScanner s = Scanner d r 0 1
  where [d, r] = map read $ splitOn ": " s

tickOne :: Scanner -> Scanner
tickOne (Scanner depth range pos dir)
  | pos <= 0         = Scanner depth range (pos+1) 1
  | pos >= range - 1 = Scanner depth range (pos-1) (-1)
  | otherwise        = Scanner depth range (pos+dir) dir

tick :: [Scanner] -> [Scanner]
tick = map tickOne

traverseFW :: [Scanner] -> [(Int, Int)]
traverseFW = traverseFW' 0
  where
    traverseFW' _ [] = []
    traverseFW' layer scanners@((Scanner depth range pos _):rest)
      -- | layer == depth && pos == 0  = (depth*range) + (traverseFW' (layer+1) $ tick rest)
      | layer == depth && pos == 0  = (depth,range) : (traverseFW' (layer+1) $ tick rest)
      | layer == depth && pos /= 0  = traverseFW' (layer+1) $ tick rest
      | otherwise                   = traverseFW' (layer+1) $ tick scanners

severity :: [Scanner] -> Int
severity = sum . map (uncurry (*)) . traverseFW

empty :: [a] -> Bool
empty [] = True
empty _ = False
  
findDelay :: [Scanner] -> Int
findDelay scanners = delay
  where
    (delay, _) = head $ filter (empty . traverseFW . snd) $ zip [0..] $ iterate tick scanners
    

main = do
  scanners <- fmap (map parseScanner . lines) getContents

  putStrLn $ "Severity: " ++ (show $ severity scanners)
  putStrLn $ "Delay: " ++ (show $ findDelay scanners)
```
