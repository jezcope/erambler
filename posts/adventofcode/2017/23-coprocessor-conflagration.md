---
title: "Coprocessor Conflagration — Haskell — #adventofcode Day 23"
description: "In which I help an overloaded coprocessor cool off."
slug: day-23
date: 2017-12-24T19:47:43+00:00
tags:
- Technology
- Learning
- Advent of Code
- Haskell
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/23) requires us to understand why a coprocessor is working so hard to perform an apparently simple calculation.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/23-coprocessor-conflagration.hs)

!!! commentary
    Today's problem is based on an assembly-like language very similar to [day 18](../18-duet/), so I went back and adapted my code from that, which works well for the first part. I've also incorporated some [advice from /r/haskell](https://www.reddit.com/r/haskell/comments/7lnrvv/code_review_parsing_state_monad_and_strict/), and cleaned up all warnings shown by the `-Wall` compiler flag and the `hlint` tool.
    
    Part 2 requires the algorithm to run with much larger inputs, and since some analysis shows that it's an `O(n^3)` algorithm it gets intractible pretty fast. There are several approaches to this. First up, if you have a fast enough processor and an efficient enough implementation I suspect that the simulation would probably terminate eventually, but that would likely still take hours: not good enough. I also thought about doing some peephole optimisations on the instructions, but the last time I did compiler optimisation was my degree so I wasn't really sure where to start. What I ended up doing was actually analysing the input code by hand to figure out what it was doing, and then just doing that calculation in a sensible way. I'd like to say I managed this on my own (and I ike to think I would have) but I did get some tips on [/r/adventofcode](https://reddit.com/r/adventofcode).
    
The majority of this code is simply a cleaned-up version of day 18, with some tweaks to accommodate the different instruction set:

```haskell
module Main where

import qualified Data.Vector as V
import qualified Data.Map.Strict as M
import Control.Monad.State.Strict
import Text.ParserCombinators.Parsec hiding (State)

type Register = Char
type Value = Int
type Argument = Either Value Register
data Instruction = Set Register Argument
                 | Sub Register Argument
                 | Mul Register Argument
                 | Jnz Argument Argument
  deriving Show
type Program = V.Vector Instruction
data Result = Cont | Halt deriving (Eq, Show)

type Registers = M.Map Char Int
data Machine = Machine { dRegisters :: Registers
                       , dPtr :: !Int
                       , dMulCount :: !Int
                       , dProgram :: Program }

instance Show Machine where
  show d = show (dRegisters d) ++ " @" ++ show (dPtr d) ++ " ×" ++ show (dMulCount d)

defaultMachine :: Machine
defaultMachine = Machine M.empty 0 0 V.empty

type MachineState = State Machine

program :: GenParser Char st Program
program = do
  instructions <- endBy instruction eol
  return $ V.fromList instructions
  where
    instruction = try (regOp "set" Set) <|> regOp "sub" Sub
                  <|> regOp "mul" Mul <|> jump "jnz" Jnz
    regOp n c = do
      string n >> spaces
      val1 <- oneOf "abcdefgh"
      secondArg c val1
    jump n c = do
      string n >> spaces
      val1 <- regOrVal
      secondArg c val1
    secondArg c val1 = do
      spaces
      val2 <- regOrVal
      return $ c val1 val2
    regOrVal = register <|> value
    register = do
      name <- lower
      return $ Right name
    value = do
      val <- many $ oneOf "-0123456789"
      return $ Left $ read val
    eol = char '\n'

parseProgram :: String -> Either ParseError Program
parseProgram = parse program ""

getReg :: Char -> MachineState Int
getReg r = do
  st <- get
  return $ M.findWithDefault 0 r (dRegisters st)

putReg :: Char -> Int -> MachineState ()
putReg r v = do
  st <- get
  let current = dRegisters st
      new = M.insert r v current
  put $ st { dRegisters = new }

modReg :: (Int -> Int -> Int) -> Char -> Argument -> MachineState ()
modReg op r v = do
  u <- getReg r
  v' <- getRegOrVal v
  putReg r (u `op` v')
  incPtr

getRegOrVal :: Argument -> MachineState Int
getRegOrVal = either return getReg

addPtr :: Int -> MachineState ()
addPtr n = do
  st <- get
  put $ st { dPtr = n + dPtr st }

incPtr :: MachineState ()
incPtr = addPtr 1

execInst :: Instruction -> MachineState ()
execInst (Set reg val) = do
  newVal <- getRegOrVal val
  putReg reg newVal
  incPtr
execInst (Mul reg val) = do
  result <- modReg (*) reg val
  st <- get
  put $ st { dMulCount = 1 + dMulCount st }
  return result
execInst (Sub reg val) = modReg (-) reg val
execInst (Jnz val1 val2) = do
  test <- getRegOrVal val1
  jump <- if test /= 0 then getRegOrVal val2 else return 1
  addPtr jump

execNext :: MachineState Result
execNext = do
  st <- get
  let prog = dProgram st
      p = dPtr st
  if p >= length prog then return Halt else do
    execInst (prog V.! p)
    return Cont

runUntilTerm :: MachineState ()
runUntilTerm = do
  result <- execNext
  unless (result == Halt) runUntilTerm
```

This implements the actual calculation: the number of non-primes between (for my input) 107900 and 124900:

```haskell
optimisedCalc :: Int -> Int -> Int -> Int
optimisedCalc a b k = sum $ map (const 1) $ filter notPrime [a,a+k..b]
  where
    notPrime n = elem 0 $ map (mod n) [2..(floor $ sqrt (fromIntegral n :: Double))]

main :: IO ()
main = do
  input <- getContents  
  case parseProgram input of
    Right prog -> do
      let c = defaultMachine { dProgram = prog }
          (_, c') = runState runUntilTerm c
      putStrLn $ show (dMulCount c') ++ " multiplications made"
      putStrLn $ "Calculation result: " ++ show (optimisedCalc 107900 124900 17)
    Left e -> print e
```
