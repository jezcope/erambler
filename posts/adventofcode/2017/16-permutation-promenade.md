---
title: "Permutation Promenade — Julia — #adventofcode Day 16"
description: "In which brute force simply doesn't work."
slug: day-16
date: 2017-12-16T15:58:38+00:00
tags:
- Technology
- Learning
- Advent of Code
- Julia
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/16) rather appeals to me as a folk dancer, because it describes a set of instructions for a dance and asks us to work out the positions of the dancing programs after each run through the dance.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/16-permutation-promenade.jl)

!!! commentary
    So, part 1 is pretty straight forward: parse the set of instructions, interpret them and keep track of the dancer positions as you go. One time through the dance. However, part 2 asks for the positions after 1 billion (yes, that's 1,000,000,000) times through the dance. In hindsight I should have immediately become suspicious, but I thought I'd at least try the brute force approach first because it was simpler to code.
    
    So I give it a try, and after waiting for a while, having a cup of tea etc. it still hasn't terminated. I try reducing the number of iterations to 1,000. Now it terminates, but takes about 6 seconds. A spot of arithmetic suggests that running the full version will take a little over 190 years. There must be a better way than that!
    
    I'm a little embarassed that I didn't spot the solution immediately (blaming Julia) and tried again in Python to see if I could get it to terminate quicker. When that didn't work I had to think again. A little further investigation with a while loop shows that in fact the dance position repeats (in the case of my input) every 48 times. After that it becomes much quicker!
    
    Oh, and it was time for a new language, so I wasted some extra time working out the quirks of [Julia][].

[Julia]: https://julialang.org/

First, a function to evaluate a single move — for neatness, this dispatches to a dedicated function depending on the type of move, although this isn't really necessary to solve the challenge. Ending a function name with a bang (`!`) is a Julia convention to indicate that it has side-effects.

```julia
function eval_move!(move, dancers)
    move_type = move[1]
    params = move[2:end]
    if move_type == 's' # spin
        eval_spin!(params, dancers)
    elseif move_type == 'x' # exchange
        eval_exchange!(params, dancers)
    elseif move_type == 'p' # partner swap
        eval_partner!(params, dancers)
    end
end
```

These take care of the individual moves. Parsing the parameters from a string *every single time* probably isn't ideal, but as it turns out, that optimisation isn't really necessary. Note the `+ 1` in `eval_exchange!`, which is necessary because Julia is one of those [crazy languages where indexes start from 1 instead of 0][array indexing]. These actions are pretty nice to implement, because Julia has `circshift` as a builtin to rotate a list, and allows you to assign to list slices and swap values in place with a single statement.

```julia
function eval_spin!(params, dancers)
    shift = parse(Int, params)
    dancers[1:end] = circshift(dancers, shift)
end

function eval_exchange!(params, dancers)
    i, j = map(x -> parse(Int, x) + 1, split(params, "/"))
    dancers[i], dancers[j] = dancers[j], dancers[i]
end

function eval_partner!(params, dancers)
    a, b = split(params, "/")
    ia = findfirst([x == a for x in dancers])
    ib = findfirst([x == b for x in dancers])
    dancers[ia], dancers[ib] = b, a
end
```

`dance!` takes a list of moves and takes the dances once through the dance.

```julia
function dance!(moves, dancers)
    for m in moves
        eval_move!(m, dancers)
    end
end
```

To solve part 1, we simply need to read the moves in, set up the initial positions of the dances and run the dance through once. `join` is necessary to a) turn characters into length-1 strings, and b) convert the list of strings back into a single string to print out.

```julia
moves = split(readchomp(STDIN), ",")
dancers = collect(join(c) for c in 'a':'p')
orig_dancers = copy(dancers)

dance!(moves, dancers)
println(join(dancers))
```

Part 2 requires a little more work. We run the dance through again and again until we get back to the initial position, saving the intermediate positions in a list. The list now contains *every possible position* available from that starting point, so we can find position 1 billion by taking 1,000,000,000 modulo the list length (plus 1 because 1-based indexing) and use that to index into the list to get the final position.

```julia
dance_cycle = [orig_dancers]
while dancers != orig_dancers
    push!(dance_cycle, copy(dancers))
    dance!(moves, dancers)
end

println(join(dance_cycle[1_000_000_000 % length(dance_cycle) + 1]))
```

This terminates on my laptop in about 1.6s: Brute force 0; Careful thought 1!

[array indexing]: https://en.wikipedia.org/wiki/Comparison_of_programming_languages_(array)#Array_system_cross-reference_list
