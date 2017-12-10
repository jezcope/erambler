---
title: "Spiral Memory — Go — #adventofcode Day 3"
description: "In which I drive myself crazy with maths."
slug: day-03
date: 2017-12-05T18:06:52+00:00
tags:
- Technology
- Learning
- Advent of Code
- Golang
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/3) requires us to perform some calculations on an "experimental memory layout", with cells moving outwards from the centre of a square spiral (squiral?).

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/03-spiral-memory.go)

!!! commentary
    I've been wanting to try my hand at [Go](https://golang.com), the memory-safe, statically typed compiled language from Google for a while. Today's challenge seemed a bit more mathematical in nature, meaning that I wouldn't need too many advanced language features or knowledge of a standard library, so I thought I'd give it a "go". It might have been my imagination, but it was impressive how quickly the compiled program chomped through 60 different input values while I was debugging.
    
    I actually spent far too long on this problem because my brain led me down a blind alley trying to do the wrong calculation, but I got there in the end! The solution is a bit difficult to explain without diagrams, which I don't really have time to draw right now, but fear not because several other people have. First take a look at [the challenge itself which explains the spiral memory concept](http://adventofcode.com/2017/day/3). Then look at the [nice diagrams that Phil Tooley made with Python](http://acceleratedscience.co.uk/blog/adventofcode-day-3-spiral-memory/) and hopefully you'll be able to see what's going on!
    
    It's interesting to note that this challenge also admits of an algorithmic solution instead of the mathematical one: you can model the memory as an infinite grid using a suitable data structure and literally move around it in a spiral. In hindsight this is a much better way of solving the challenge quickly because it's easier and less error-prone to code. I'm quite pleased with my maths-ing though, and it's much quicker than the algorithmic version!
    
First some Go boilerplate: we have to define the package we're in (`main`, because it's an executable we're producing) and import the libraries we'll use.

```go
package main

import (
	"fmt"
	"math"
	"os"
)
```

Weirdly, Go doesn't seem to have these basic mathematics functions for integers in its standard library (please someone correct me if I'm wrong!) so I'll define them instead of mucking about with data types. Go doesn't do any implicit type conversion, even between numeric types, and the `math` builtin package only operates on `float64` values.

```go
func abs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

func min(x, y int) int {
	if x < y {
		return x
	}
	return y
}

func max(x, y int) int {
	if x > y {
		return x
	}
	return y
}
```

This does the heavy lifting for part one: converting from a position on the spiral to a column and row in the grid. `(0, 0)` is the centre of the spiral. This actually does a bit more than is necessary to calculate the distance as required for part 1, but we'll use it again for part 2.

```go
func spiral_to_xy(n int) (int, int) {
	if n == 1 {
		return 0, 0
	}

	r := int(math.Floor((math.Sqrt(float64(n-1)) + 1) / 2))
	n_r := n - (2*r-1)*(2*r-1)
	o := ((n_r - 1) % (2 * r)) - r + 1
	sector := (n_r - 1) / (2 * r)

	switch sector {
	case 0:
		return r, o
	case 1:
		return -o, r
	case 2:
		return -r, -o
	case 3:
		return o, -r
	}

	return 0, 0
}
```

Now use `spiral_to_xy` to calculate the Manhattan distance that the value at location `n` in the spiral memory are carried to reach the "access port" at 0.

```go
func distance(n int) int {
	x, y := spiral_to_xy(n)

	return abs(x) + abs(y)
}
```

This function does the opposite of `spiral_to_xy`, translating a grid position back to its position on the spiral. This is the one that took me far too long to figure out because I had a brain bug and tried to calculate the value `s` (which sector or quarter of the spiral we're looking at) in a way that was never going to work! Fortunately I came to my senses.

```go
func xy_to_spiral(x, y int) int {
	if x == 0 && y == 0 {
		return 1
	}

	r := max(abs(x), abs(y))
	var s, o, n int

	if x+y > 0 && x-y >= 0 {
		s = 0
	} else if x-y < 0 && x+y >= 0 {
		s = 1
	} else if x+y < 0 && x-y <= 0 {
		s = 2
	} else {
		s = 3
	}

	switch s {
	case 0:
		o = y
	case 1:
		o = -x
	case 2:
		o = -y
	case 3:
		o = x
	}

	n = o + r*(2*s+1) + (2*r-1)*(2*r-1)

	return n
}
```

This is a utility function that uses `xy_to_spiral` to fetch the value at a given `(x, y)` location, and returns zero if we haven't filled that location yet.

```go
func get_spiral(mem []int, x, y int) int {
	n := xy_to_spiral(x, y) - 1
	if n < len(mem) {
		return mem[n]
	}

	return 0
}
```

Finally we solve part 2 of the problem, which involves going round the spiral writing values into it that are the sum of some values already written. The result is the first of these sums that is greater than or equal to the given `input` value.

```go
func stress_test(input int) int {
	mem := make([]int, 1)
	n := 0
	mem[0] = 1

	for mem[n] < input {
		n++
		x, y := spiral_to_xy(n + 1)
		mem = append(mem,
			get_spiral(mem, x+1, y)+
				get_spiral(mem, x+1, y+1)+
				get_spiral(mem, x, y+1)+
				get_spiral(mem, x-1, y+1)+
				get_spiral(mem, x-1, y)+
				get_spiral(mem, x-1, y-1)+
				get_spiral(mem, x, y-1)+
				get_spiral(mem, x+1, y-1))
	}

	return mem[n]
}
```

Now the last part of the program puts it all together, reading the input value from a commandline argument and printing the results of the two parts of the challenge:

```go
func main() {
	var n int
	fmt.Sscanf(os.Args[1], "%d", &n)

	fmt.Printf("Input is %d\n", n)
	fmt.Printf("Distance is %d\n", distance(n))
	fmt.Printf("Stress test result is %d\n", stress_test(n))
}
```
