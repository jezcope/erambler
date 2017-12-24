---
title: "Duet — Haskell — #adventofcode Day 18"
description: "In which I finally (maybe) understand monads and start to take control of laziness."
slug: day-18
date: 2017-12-24T17:59:01+00:00
tags:
- Technology
- Learning
- Advent of Code
- Haskell
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/18) introduces a type of simplified assembly language that includes instructions for message-passing. First we have to simulate a single program (after humorously misinterpreting the `snd` and `rcv` instructions as "sound" and "recover"), but then we have to simulate *two* concurrent processes and the message passing between them.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/18-duet.hs)

!!! commentary
    Well, I really learned a lot from this one! I wanted to get to grips with more complex stuff in Haskell and this challenge seemed like an excellent opportunity to figure out a) parsing with the `parsec` library and b) using the `State` [monad](http://en.wikipedia.org/wiki/Monad) to keep the state of the simulator.
    
    As it turned out, that wasn't all I'd learned: I also ran into an interesting situation whereby lazy evaluation was creating an infinite loop where there shouldn't be one, so I also had to learn how to selectively force strict evaluation of values. I'm pretty sure this isn't the best Haskell in the world, but I'm proud of it.

First we have to import a bunch of stuff to use later, but also notice the pragma on the first line which instructs the compiler to enable the `BangPatterns` language extension, which will be important later.

```haskell
{-# LANGUAGE BangPatterns #-}
module Main where

import qualified Data.Vector as V
import qualified Data.Map.Strict as M
import Data.List
import Data.Either
import Data.Maybe
import Control.Monad.State.Strict
import Control.Monad.Loops
import Text.ParserCombinators.Parsec hiding (State)
```

First up we define the types that will represent the program code itself.

```haskell
data DuetVal = Reg Char | Val Int deriving Show
type DuetQueue = [Int]
data DuetInstruction = Snd DuetVal
                       | Rcv DuetVal
                       | Jgz DuetVal DuetVal
                       | Set DuetVal DuetVal
                       | Add DuetVal DuetVal
                       | Mul DuetVal DuetVal
                       | Mod DuetVal DuetVal
                        deriving Show
type DuetProgram = V.Vector DuetInstruction
```

Next we define the types to hold the machine state, which includes: registers, instruction pointer, send & receive buffers and the program code, plus a counter of the number of sends made (to provide the solution).

```haskell
type DuetRegisters = M.Map Char Int
data Duet = Duet { dRegisters :: DuetRegisters
                 , dPtr :: Int
                 , dSendCount :: Int
                 , dRcvBuf :: DuetQueue
                 , dSndBuf :: DuetQueue
                 , dProgram :: DuetProgram }

instance Show Duet where
  show d = show (dRegisters d) ++ " @" ++ show (dPtr d) ++ " S" ++ show (dSndBuf d) ++ " R" ++ show (dRcvBuf d)

defaultDuet = Duet M.empty 0 0 [] [] V.empty

type DuetState = State Duet
```

`program` is a parser built on the cool `parsec` library to turn the program text into a Haskell format that we can work with, a `Vector` of instructions. Yes, using a full-blown parser is overkill here (it would be much simpler just to split each line on whitespace, but I wanted to see how Parsec works. I'm using `Vector` here because we need random access to the instruction list, which is much more efficient with `Vector`: `O(1)` compared with the `O(n)` of the built in Haskell list (`[]`) type. `parseProgram` applies the parser to a string and returns the result.

```haskell
program :: GenParser Char st DuetProgram
program = do
  instructions <- endBy instruction eol
  return $ V.fromList instructions
  where
    instruction = try (oneArg "snd" Snd) <|> oneArg "rcv" Rcv
                  <|> twoArg "set" Set <|> twoArg "add" Add
                  <|> try (twoArg "mul" Mul)
                  <|> twoArg "mod" Mod <|> twoArg "jgz" Jgz
    oneArg n c = do
      string n >> spaces
      val <- regOrVal
      return $ c val
    twoArg n c = do
      string n >> spaces
      val1 <- regOrVal
      spaces
      val2 <- regOrVal
      return $ c val1 val2
    regOrVal = register <|> value
    register = do
      name <- lower
      return $ Reg name
    value = do
      val <- many $ oneOf "-0123456789"
      return $ Val $ read val
    eol = char '\n'

parseProgram :: String -> Either ParseError DuetProgram
parseProgram = parse program ""
```

Next up we have some utility functions that sit in the `DuetState` monad we defined above and perform common manipulations on the state: getting/setting/updating registers, updating the instruction pointer and sending/receiving messages via the relevant queues.

```haskell
getReg :: Char -> DuetState Int
getReg r = do
  st <- get
  return $ M.findWithDefault 0 r (dRegisters st)

putReg :: Char -> Int -> DuetState ()
putReg r v = do
  st <- get
  let current = dRegisters st
      new = M.insert r v current
  put $ st { dRegisters = new }

modReg :: (Int -> Int -> Int) -> Char -> DuetVal -> DuetState Bool
modReg op r v = do
  u <- getReg r
  v' <- getRegOrVal v
  putReg r (u `op` v')
  incPtr
  return False

getRegOrVal :: DuetVal -> DuetState Int
getRegOrVal (Reg r) = getReg r
getRegOrVal (Val v) = return v

addPtr :: Int -> DuetState ()
addPtr n = do
  st <- get
  put $ st { dPtr = n + dPtr st }

incPtr = addPtr 1

send :: Int -> DuetState ()
send v = do
  st <- get
  put $ st { dSndBuf = (dSndBuf st ++ [v]), dSendCount = dSendCount st + 1 }

recv :: DuetState (Maybe Int)
recv = do
  st <- get
  case dRcvBuf st of
    (x:xs) -> do
      put $ st { dRcvBuf = xs }
      return $ Just x
    [] -> return Nothing
```
    
`execInst` implements the logic for each instruction. It returns `False` as long as the program can continue, but `True` if the program tries to receive from an empty buffer.

```haskell
execInst :: DuetInstruction -> DuetState Bool
execInst (Set (Reg reg) val) = do
  newVal <- getRegOrVal val
  putReg reg newVal
  incPtr
  return False
execInst (Mul (Reg reg) val) = modReg (*) reg val
execInst (Add (Reg reg) val) = modReg (+) reg val
execInst (Mod (Reg reg) val) = modReg mod reg val
execInst (Jgz val1 val2) = do
  st <- get
  test <- getRegOrVal val1
  jump <- if test > 0 then getRegOrVal val2 else return 1
  addPtr jump
  return False
execInst (Snd val) = do
  v <- getRegOrVal val
  send v
  st <- get
  incPtr
  return False
execInst (Rcv (Reg r)) = do
  st <- get
  v <- recv
  handle v
  where
    handle :: Maybe Int -> DuetState Bool
    handle (Just x) = putReg r x >> incPtr >> return False
    handle Nothing = return True
execInst x = error $ "execInst not implemented yet for " ++ show x
```

`execNext` looks up the next instruction and executes it. `runUntilWait` runs the program until `execNext` returns `True` to signal the wait state has been reached.

```haskell
execNext :: DuetState Bool
execNext = do
  st <- get
  let prog = dProgram st
      p = dPtr st
  if p >= length prog then return True else execInst (prog V.! p)

runUntilWait :: DuetState ()
runUntilWait = do
  waiting <- execNext
  unless waiting runUntilWait
```
  
`runTwoPrograms` handles the concurrent running of two programs, by running first one and then the other to a wait state, then swapping each program's send buffer to the other's receive buffer before repeating.

If you look carefully, you'll see a "bang" (`!`) before the two arguments of the function: `runTwoPrograms !d0 !d1`. Haskell is a lazy language and usually doesn't evaluate a computation until you ask for a result, instead carrying around a "thunk" or plan for how to carry out the computation. Sometimes that can be a problem because the amount of memory your program is using can explode unnecessarily as a long computation turns into a large thunk which isn't evaluated until the very end. That's not the problem here though.

What happens here without the bangs is another side-effect of laziness. The exit condition of this recursive function is that a deadlock has been reached: both programs are waiting to receive, but neither has sent anything, so neither can ever continue. The check for this is `(null $ dSndBuf d0') && (null $ dSndBuf d1')`. As long as the first program has something in its send buffer, the test fails without ever evaluating the second part, which means the result `d1'` of running the second program is never needed. The function immediately goes to the recursive case and tries to continue the first program again, which immediately returns because it's *still* waiting to receive. The same thing happens again, and the result is that instead of running the second program to obtain something for the first to receive, we get into an infinite loop trying and failing to continue the first program.

The bang forces both `d0` and `d1` to be evaluated at the point we recurse, which forces the rest of the computation: running the second program and swapping the send/receive buffers. With that, the evaluation proceeds correctly and we terminate with a result instead of getting into an infinite loop!

```haskell
runTwoPrograms :: Duet -> Duet -> (Int, Int)
runTwoPrograms !d0 !d1
  | (null $ dSndBuf d0') && (null $ dSndBuf d1') = (dSendCount d0', dSendCount d1')
  | otherwise = runTwoPrograms d0'' d1''
  where
    (_, d0') = runState runUntilWait d0
    (_, d1') = runState runUntilWait d1
    d0'' = d0' { dSndBuf = [], dRcvBuf = dSndBuf d1' }
    d1'' = d1' { dSndBuf = [], dRcvBuf = dSndBuf d0' }
```

All that remains to be done now is to run the programs and see how many messages were sent before the deadlock.

```haskell
main = do
  prog <- fmap (fromRight V.empty . parseProgram) getContents  
  let d0 = defaultDuet { dProgram = prog, dRegisters = M.fromList [('p', 0)] }
      d1 = defaultDuet { dProgram = prog, dRegisters = M.fromList [('p', 1)] }
      (send0, send1) = runTwoPrograms d0 d1
  putStrLn $ "Program 0 sent " ++ show send0 ++ " messages"
  putStrLn $ "Program 1 sent " ++ show send1 ++ " messages"
```
