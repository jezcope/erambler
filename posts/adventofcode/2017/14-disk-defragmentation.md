---
title: "Disk Defragmentation — Haskell — #adventofcode Day 14"
description: "In which I learn how that old flood fill tool in Microsoft Paint works."
slug: day-14
date: 2017-12-15T17:52:46+00:00
tags:
- Technology
- Learning
- Advent of Code
- Haskell
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/14) has us helping a disk defragmentation program by identifying contiguous regions of used sectors on a 2D disk.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/14-disk-defragmentation.hs)

!!! commentary
    Wow, today's challenge had a pretty steep learning curve. Day 14 was the first to directly reuse code from a previous day: [the "knot hash" from day 10][day 10]. I [solved day 10 in Haskell](../day-10/), so I thought it would be easier to stick with Haskell for today as well. The first part was straightforward, but the second was pretty mind-bending in a pure functional language!

    I ended up solving it by implementing a [flood fill algorithm][flood]. It's recursive, which is right in Haskell's wheelhouse, but I ended up using `Data.Sequence` instead of the standard list type as its API for indexing is better. I haven't tried it, but I think it will also be a little faster than a naive list-based version.
    
    It took a looong time to figure everything out, but I had a day off work to be able to concentrate on it!

[day 10]: http://adventofcode.com/2017/day/10
[flood]: https://en.wikipedia.org/wiki/Flood_fill

A lot more imports for this solution, as we're exercising a lot more of the standard library.

```haskell
module Main where

import Prelude hiding (length, filter, take)
import Data.Char (ord)
import Data.Sequence
import Data.Foldable hiding (length)
import Data.Ix (inRange)
import Data.Function ((&))
import Data.Maybe (fromJust, mapMaybe, isJust)
import qualified Data.Set as Set
import Text.Printf (printf)
import System.Environment (getArgs)
```

Also we'll extract the key bits from day 10 into a module and import that.

```haskell
import KnotHash
```

Now we define a few data types to make the code a bit more readable. `Sector` represent the state of a particular disk sector, either free, used (but unmarked) or used and marked as belonging to a given integer-labelled group. `Grid` is a 2D matrix of `Sector`, as a sequence of sequences.

```haskell
data Sector = Free | Used | Mark Int
  deriving (Eq)

instance Show Sector where
  show Free = "   ."
  show Used = "   #"
  show (Mark i) = printf "%4d" i

type GridRow = Seq Sector
type Grid = Seq (GridRow)
```

Some utility functions to make it easier to view the grids (which can be quite large): used for debugging but not in the finished solution.

```haskell
subGrid :: Int -> Grid -> Grid
subGrid n = fmap (take n) . take n

printRow :: GridRow -> IO ()
printRow row = do
  mapM_ (putStr . show) row
  putStr "\n"

printGrid :: Grid -> IO ()
printGrid = mapM_ printRow
```

`makeKey` generates the hash key for a given row.

```haskell
makeKey :: String -> Int -> String
makeKey input n = input ++ "-" ++ show n
```

`stringToGridRow` converts a binary string of '1' and '0' characters to a sequence of `Sector` values.

```haskell
stringToGridRow :: String -> GridRow
stringToGridRow = fromList . map convert
  where convert x
          | x == '1' = Used
          | x == '0' = Free
```

`makeRow` and `makeGrid` build up the grid to use based on the provided input string.

```haskell
makeRow :: String -> Int -> GridRow
makeRow input n = stringToGridRow $ concatMap (printf "%08b")
  $ dense $ fullKnotHash 256
  $ map ord $ makeKey input n

makeGrid :: String -> Grid
makeGrid input = fromList $ map (makeRow input) [0..127]
```

Utility functions to count the number of used and free sectors, to give the solution to part 1.

```haskell
countEqual :: Sector -> Grid -> Int
countEqual x = sum . fmap (length . filter (==x))

countUsed = countEqual Used
countFree = countEqual Free
```

Now the real meat begins! `fundUnmarked` finds the location of the next used sector that we haven't yet marked. It returns a `Maybe` value, which is `Just (x, y)` if there is still an unmarked block or `Nothing` if there's nothing left to mark.

```haskell
findUnmarked :: Grid -> Maybe (Int, Int)
findUnmarked g
  | y == Nothing = Nothing
  | otherwise = Just (fromJust x, fromJust y)
  where
    hasUnmarked row = isJust $ elemIndexL Used row
    x = findIndexL hasUnmarked g
    y = case x of
      Nothing -> Nothing
      Just x' -> elemIndexL Used $ index g x'
```

`floodFill` implements a very simple recursive flood fill. It takes a target and replacement value and a starting location, and fills in the replacement value for every *connected* location that currently has the target value. We use it below to replace a connected used region with a marked region.

```haskell
floodFill :: Sector -> Sector -> (Int, Int) -> Grid -> Grid
floodFill t r (x, y) g
  | inRange (0, length g - 1) x
    && inRange (0, length g - 1) y
    && elem == t =
      let newRow = update y r row
          newGrid = update x newRow g
      in newGrid
         & floodFill t r (x+1, y)
         & floodFill t r (x-1, y)
         & floodFill t r (x, y+1)
         & floodFill t r (x, y-1)
  | otherwise = g
  where
    row = g `index` x
    elem = row `index` y
```

`markNextGroup` looks for an unmarked group and marks it if found. If no more groups are found it returns `Nothing`. `markAllGroups` then repeatedly applies `markNextGroup` until `Nothing` is returned.

```haskell
markNextGroup :: Int -> Grid -> Maybe Grid
markNextGroup i g = case findUnmarked g of
                      Nothing -> Nothing
                      Just loc -> Just $ floodFill Used (Mark i) loc g

markAllGroups :: Grid -> Grid
markAllGroups g = markAllGroups' 1 g
  where
    markAllGroups' i g = case markNextGroup i g of
      Nothing -> g
      Just g' -> markAllGroups' (i+1) g'
```

`onlyMarks` filters a grid row and returns a list of (possibly duplicated) group numbers in the row.

```haskell
onlyMarks :: GridRow -> [Int]
onlyMarks = mapMaybe getMark . toList
  where
    getMark Free = Nothing
    getMark Used = Nothing
    getMark (Mark i) = Just i
```

Finally, `countGroups` puts all the group numbers into a set to get rid of duplicates and returns the size of the set, i.e. the total number of separate groups.

```haskell
countGroups :: Grid -> Int
countGroups g = Set.size groupSet
  where
    groupSet = foldl' Set.union Set.empty $ fmap rowToSet g
    rowToSet = Set.fromList . toList . onlyMarks
```

As always, every Haskell program needs a main function to drive the I/O and produce the actual result.
  
```haskell
main = do
  input <- fmap head getArgs
  let grid = makeGrid input
      used = countUsed grid
      marked = countGroups $ markAllGroups grid

  putStrLn $ "Used sectors: " ++ show used
  putStrLn $ "Groups: " ++ show marked
```
