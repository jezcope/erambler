---
title: "Why try Rust for scientific computing?"
description: "In which I try to persuade you that your next language should be Rustier."
slug: why-give-rust-a-try
date: 2018-01-11T21:31:48+00:00
type: post
tags:
- Rust
---


When you're writing analysis code, Python (or R, or JavaScript, or ...) is usually the right choice. These high-level languages are set up to make you as productive as possible, and common tasks like array manipulation have been well optimised. However, sometimes you just can't get enough speed and need to turn to a lower-level compiled language. Often that will be C, C++ or Fortran, but I thought I'd do a short post on why I think you should consider [Rust](http://rust-lang.org/).

One of my goals for 2017's Advent of Code was to learn a modern, memory-safe, statically-typed language. I now know that there are quite a lot of options in this space, but two seem to stand out: Go & Rust. I gave both of them a try, and although I'll probably go back to give Go a more thorough test at some point I found I got quite hooked on Rust.

Both languages, though young, are definitely production-ready. Servo, the core of the new Firefox browser, is entirely written in Rust. In fact, Mozilla have been trying to rewrite the rendering core in C for nearly a decade, and switching to Rust let them get it done in just a couple of years.

!!! tldr "TL;DR"
    - It's fast: competitive with idiomatic C/C++, and no garbage-collection overhead
    - It's harder to write buggy code, and compiler errors are actually helpful
    - It's C-compatible: you can call into Rust code anywhere you'd call into C, call C/C++ from Rust, and incrementally replace C/C++ code with Rust
    - It has sensible modern syntax that makes your code clearer and more concise
    - Support for scientific computing are getting better all the time (matrix algebra libraries, built-in SIMD, safe concurrency)
    - It has a really friendly and active community
    - It's production-ready: Servo, the new rendering core in Firefox, is built entirely in Rust

### Performance

To start with, as a compiled language Rust executes *much* faster than a (pseudo-)interpreted language like Python or R; the price you pay for this is time spent compiling during development. However, having a compile step also allows the language to enforce certain guarantees, such as type-correctness and memory safety, which between them prevent whole classes of bugs from even being possible.

Unlike Go (which, like many higher-level languages, uses a [garbage collector](http://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29)), Rust handles memory safety at compile time through the concepts of ownership and borrowing. These can take some getting used to and were a big source of frustration when I was first figuring out the language, but ultimately contribute to Rust's reliably-fast performance. Performance can be unpredictable in a garbage-collected language because you can't be sure when the GC is going to run and you need to understand it *really* well to stand a chance of optimising it if becomes a problem. On the other hand, code that has the potential to be unsafe will result in compilation errors in Rust.

There are a number of benchmarks ([example](http://cantrip.org/rust-vs-c++.html)) that show Rust's performance on a par with idiomatic C & C++ code, something that very few languages can boast.

### Helpful error messages

Because beginner Rust programmers often get compile errors, it's really important that those errors are easy to interpret and fix, and Rust is great at this. Not only does it tell you what went wrong, but wherever possible it prints out your code annotated with arrows to show exactly where the error is, and makes specific suggestions how to fix the error which usually turn out to be correct. It also has a nice suite of warnings (things that don't cause compilation to fail but may indicate bugs) that are just as informative, and this can be extended even further by using the clippy linting tool to further analyse your code.

```text
warning: unused variable: `y`
 --> hello.rs:3:9
  |
3 |     let y = x;
  |         ^
  |
  = note: #[warn(unused_variables)] on by default
  = note: to avoid this warning, consider using `_y` instead
```

### Easy to integrate with other languages

If you're like me, you'll probably only use a low-level language for performance-critical code that you can call from a high-level language, and this is an area where Rust shines. Most programmers will turn to C, C++ or Fortran for this because they have a well established [ABI (Application Binary Interface)](https://en.wikipedia.org/wiki/Application_binary_interface) which can be understood by languages like Python and R[^1]. 

In Rust, it's trivial to make a C-compatible shared library, and the standard library includes extra features for working with C types. That also means that existing C code can be incrementally ported to Rust: see [remacs](https://github.com/Wilfred/remacs) for an example.

On top of this, there are projects like [rust-cpython](https://github.com/dgrunwald/rust-cpython) and [PyO3](https://github.com/PyO3/pyo3) which provide macros and structures that wrap the Python C API to let you build Python modules in Rust with minimal glue code; [rustr](https://rustr.org) does a similar job for R.

### Nice language features

Rust has some really nice features, which let you write efficient, concise and correct code. Several feel particularly comfortable as they remind me of similar things available in Haskell, including:

- Enums, a super-powered combination of C enums and unions (similar to Haskell's algebraic data types) that enable some really nice code with no runtime cost
- Generics and traits that let you get more done with less code
- Pattern matching, a kind of `case` statement that lets you extract parts of structs, tuples & enums and do all sorts of other clever things
- Lazy computation based on an iterator pattern, for efficient processing of lists of things: you can do `for item in list { ... }` instead of the C-style use of an index[^2], or you can use higher-order functions like `map` and `filter`
- Functions/closures as first-class citizens

### Scientific computing

Although it's a general-purpose language and not designed *specifically* for scientific computing, Rust's support is improving all the time. There are some interesting matrix algebra libraries available, and built-in SIMD is incoming. The memory safety features also work to ensure thread safety, so it's harder to write concurrency bugs. You should be able to use your favourite MPI implementation too, and there's at least one attempt to portably wrap MPI in a more Rust-like way.

### Active development and friendly community 

One of the things you notice straight away is how active and friendly the Rust community is. There are several IRC channels on [irc.mozilla.org](https://wiki.mozilla.org/IRC) including `#rust-beginners`, which is a great place to get help. The compiler is under constant but carefully-managed development, so that new features are landing all the time but without breaking existing code. And the fabulous [Cargo](https://doc.rust-lang.org/cargo/) build tool and [crates.io](https://crates.io) are enabling the rapid growth of a healthy ecosystem of open source libraries that you can use to write less code yourself.

### Summary

So, next time you need a compiled language to speed up hotspots in your code, try [Rust](http://rust-lang.org/). I promise you won't regret it!

[^1]: Julia actually allows you to call C and Fortran functions as a first-class language feature

[^2]: Actually, since C++11 there's `for (auto item : list) { ... }` but still...
