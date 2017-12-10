---
title: "Stream Processing — Haskell — #adventofcode Day 9"
description: "In which I use Haskell to throw out the garbage."
slug: day-09
date: 2017-12-10T20:57:21+00:00
tags:
- Technology
- Learning
- Advent of Code
- Haskell
series: aoc2017
---

In [today's challenge](http://adventofcode.com/2017/day/9) we come across a stream that we need to cross. But of course, because we're stuck inside a computer, it's not water but data flowing past. The stream is too dangerous to cross until we've removed all the garbage, and to prove we can do that we have to calculate a score for the valid data "groups" and the number of garbage characters to remove.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/09-stream-processing.hs)

!!! commentary
    One of my goals for this process was to knock the rust of my functional programming skills in Haskell, and I haven't done that for the whole of the first week. Processing strings character by character and acting according to which character shows up seems like a good choice for pattern-matching though, so here we go. I also wanted to take a bash at test-driven development in Haskell, so I also loaded up the `Test.Hspec` module to give it a try.
    
    I did find keeping track of all the state in arguments a bit mind boggling, and I think it could have been improved through use of a data type using record syntax and the `State` monad, so that's something to look at for a future challenge.
    
First import the extra bits we'll need.

```haskell
module Main where

import Test.Hspec
import Data.Function ((&))
```

`countGroups` solves the first part of the problem, counting up the "score" of the valid data in the stream. `countGroups'` is an auxiliary function that holds some state in its arguments. We use pattern matching for the base case: `[]` represents the empty list in Haskell, which indicates we've finished the whole stream. Otherwise, we split the remaining stream into its first character and remainder, and use guards to decide how to interpret it. If `skip` is true, discard the character and carry on with `skip` set back to false. If we find a "!", that tells us to skip the next. Other characters mark groups or sets of garbage: groups increase the score when they close and garbage is discarded. We continue to progress the list by recursing with the remainder of the stream and any updated state.

```haskell
countGroups :: String -> Int
countGroups = countGroups' 0 0 False False
  where
    countGroups' score _ _ _ [] = score
    countGroups' score level garbage skip (c:rest)
      | skip      = countGroups' score level garbage False rest
      | c == '!'  = countGroups' score level garbage True rest
      | garbage   = case c of
                      '>' -> countGroups' score level False False rest
                      _   -> countGroups' score level True False rest
      | otherwise = case c of
                      '{' -> countGroups' score (level+1) False False rest
                      '}' -> countGroups' (score+level) (level-1) False False rest
                      ',' -> countGroups' score level False False rest
                      '<' -> countGroups' score level True False rest
                      c   -> error $ "Garbage character found outside garbage: " ++ show c
```

`countGarbage` works almost identically to `countGroups`, except it ignores groups and counts garbage. They are structured so similarly that it would probably make more sense to combine them to a single function that returns both counts.

```haskell
countGarbage :: String -> Int
countGarbage = countGarbage' 0 False False
  where
    countGarbage' count _ _ [] = count
    countGarbage' count garbage skip (c:rest)
      | skip      = countGarbage' count garbage False rest
      | c == '!'  = countGarbage' count garbage True rest
      | garbage   = case c of
                      '>' -> countGarbage' count False False rest
                      _   -> countGarbage' (count+1) True False rest
      | otherwise = case c of
                      '<' -> countGarbage' count True False rest
                      _   -> countGarbage' count False False rest
```

[`Hspec`](https://hspec.github.io/) gives us a domain-specific language heavily inspired by the [`rspec`](http://rspec.info/) library for Ruby: the tests read almost like natural language. I built up these tests one-by-one, gradually implementing the appropriate bits of the functions above, a process known as [Test-driven development](http://en.wikipedia.org/wiki/Test-driven_development).

```haskell
runTests = 
  hspec $ do
    describe "countGroups" $ do
      it "counts valid groups" $ do
        countGroups "{}" `shouldBe` 1
        countGroups "{{{}}}" `shouldBe` 6
        countGroups "{{{},{},{{}}}}" `shouldBe` 16
        countGroups "{{},{}}" `shouldBe` 5

      it "ignores garbage" $ do
        countGroups "{<a>,<a>,<a>,<a>}" `shouldBe` 1
        countGroups "{{<ab>},{<ab>},{<ab>},{<ab>}}" `shouldBe` 9

      it "skips marked characters" $ do
        countGroups "{{<!!>},{<!!>},{<!!>},{<!!>}}" `shouldBe` 9
        countGroups "{{<a!>},{<a!>},{<a!>},{<ab>}}" `shouldBe` 3
      

    describe "countGarbage" $ do
      it "counts garbage characters" $ do
        countGarbage "<>" `shouldBe` 0
        countGarbage "<random characters>" `shouldBe` 17
        countGarbage "<<<<>" `shouldBe` 3

      it "ignores non-garbage" $ do
        countGarbage "{{},{}}" `shouldBe` 0
        countGarbage "{{<ab>},{<ab>},{<ab>},{<ab>}}" `shouldBe` 8
        
      it "skips marked characters" $ do
        countGarbage "<{!>}>" `shouldBe` 2
        countGarbage "<!!>" `shouldBe` 0
        countGarbage "<!!!>" `shouldBe` 0
        countGarbage "<{o\"i!a,<{i<a>" `shouldBe` 10
```

Finally, the `main` function reads in the challenge input and calculates the answers, printing them on standard output.

```haskell
main = do
  runTests

  repeat '=' & take 78 & putStrLn

  input <- getContents & fmap (filter (/='\n'))
  putStrLn $ "Found " ++ show (countGroups input) ++ " groups"
  putStrLn $ "Found " ++ show (countGarbage input) ++ " characters garbage"
```
