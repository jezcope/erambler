---
title: "How to extend Python with Rust: part 1"
description: "In which I oxidise a snake."
slug: extending-python-rust-1
date: 2018-02-06T20:53:52+00:00
type: post
tags:
- Python
- Rust
- Polyglot
- Tutorials
---


Python is great, but I find it useful to have an alternative language under my belt for occasions when no amount of Pythonic cleverness will make some bit of code run fast enough. One of my main reasons for wanting to learn [Rust](https://rust-lang.org) was to have something better than C for that.

Not only does Rust have all sorts of advantages that make it a good choice for code that needs to run fast *and* correctly, it's also got a couple of rather nice crates (libraries) that make interfacing with Python a lot nicer.

Here's a little tutorial to show you how easy it is to call a simple Rust function from Python. If you want to try it yourself, you'll find the [code on GitHub][github].

!!! prerequisites
    I’m assuming for this tutorial that you’re already familiar with writing Python scripts and importing & using packages, and that you’re comfortable using the command line. You’ll also need to have [installed Rust](https://www.rust-lang.org/en-US/install.html).

## The Rust bit

The quickest way to get compiled code into Python is to use the builtin [`ctypes`](https://docs.python.org/3/library/ctypes.html) package. This is Python's ["Foreign Function Interface" or FFI](https://en.wikipedia.org/wiki/Foreign_function_interface): a means of calling functions outside the language you're using to make the call.

`ctypes` allows us to call arbitrary functions in a shared library[^1], as long as those functions conform to certain standard C language calling conventions. Thankfully, Rust tries hard to make it easy for us to build such a shared library.

[^1]: `.so` on Linux, `.dylib` on Mac and `.dll` on Windows

The first thing to do is to create a new project with cargo, the Rust build tool:

```
$ cargo new rustfrompy
     Created library `rustfrompy` project

$ tree
.
├── Cargo.toml
└── src
    └── lib.rs

1 directory, 2 files
```

!!! aside
    I use the fairly common convention that text set in `fixed-width` font is either example code or commands to type in. For the latter, a `$` precedes the command that you type (omit the `$`), and lines that don't start with a `$` are output from the previous command. I assume a basic familiarity with Unix-style command line, but I should probably put in some links to resources if you need to learn more!

We need to edit the `Cargo.toml` file and add a `[lib]` section:

```toml
[package]
name = "rustfrompy"
version = "0.1.0"
authors = ["Jez Cope <j.cope@erambler.co.uk>"]

[dependencies]

[lib]
name = "rustfrompy"
crate-type = ["cdylib"]
```

This tells cargo that we want to make a C-compatible dynamic library (`crate-type = ["cdylib"]`) and what to call it, plus some standard metadata. We can then put our code in `src/lib.rs`.

We'll just use a simple toy function that adds two numbers together:

```rust
#[no_mangle]
pub fn add(a: i64, b: i64) -> i64 {
    a + b
}
```

Notice the `pub` keyword, which instructs the compiler to make this function accessible to other modules, and the `#[no_mangle]` annotation, which tells it to use the standard C naming conventions for functions. If we don't do this, then Rust will generate a new name for the function for its own nefarious purposes, and as a side effect we won't know what to call it when we want to use it from Python.

Being good developers, let's also add a test:

```rust
#[cfg(test)]
mod test {
    use ::*;

    #[test]
    fn test_add() {
        assert_eq!(4, add(2, 2));
    }
}
```

We can now run `cargo test` which will compile that code and run the test:

```
$ cargo test
   Compiling rustfrompy v0.1.0 (file:///home/jez/Personal/Projects/rustfrompy)
    Finished dev [unoptimized + debuginfo] target(s) in 1.2 secs
     Running target/debug/deps/rustfrompy-3033caaa9f5f17aa

running 1 test
test test::test_add ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

Everything worked! Now just to build that shared library and we can try calling it from Python:

```
$ cargo build
   Compiling rustfrompy v0.1.0 (file:///home/jez/Personal/Projects/rustfrompy)
    Finished dev [unoptimized + debuginfo] target(s) in 0.30 secs
```

Notice that the build is unoptimized and includes debugging information: this is useful in development, but once we're ready to use our code it will run much faster if we compile it with optimisations. Cargo makes this easy:

```
$ cargo build --release
   Compiling rustfrompy v0.1.0 (file:///home/jez/Personal/Projects/rustfrompy)
    Finished release [optimized] target(s) in 0.30 secs
```

## The Python bit

After all that, the Python bit is pretty short. First we import the `ctypes` package (which is included in all recent Python versions):

```python
from ctypes import cdll
```

Cargo has tidied our shared library away into a folder, so we need to tell Python where to load it from. On Linux, it will be called `lib<something>.so` where the "something" is the crate name from `Cargo.toml`, "rustfrompy":

```python
lib = cdll.LoadLibrary('target/release/librustfrompy.so')
```

Finally we can call the function anywhere we want. Here it is in a pytest-style test:

```python
def test_rust_add():
    assert lib.add(27, 15) == 42
```

If you have pytest installed (and you should!) you can run the whole test like this:

```
$ pytest --verbose test.py
====================================== test session starts ======================================
platform linux -- Python 3.6.4, pytest-3.1.1, py-1.4.33, pluggy-0.4.0 -- /home/jez/.virtualenvs/datasci/bin/python
cachedir: .cache
rootdir: /home/jez/Personal/Projects/rustfrompy, inifile:
collected 1 items

test.py::test_rust_add PASSED
```

It worked! I've put [both the Rust and Python code on github if you want to try it for yourself][github].

[github]: https://github.com/jezcope/rustfrompy-example

## Shortcomings

Ok, so that was a pretty simple example, and I glossed over a lot of things. For example, what would happen if we did `lib.add(2.0, 2)`? This causes Python to throw an error because our Rust function only accepts integers (64-bit signed integers, `i64`, to be precise), and we gave it a floating point number. `ctypes` can’t guess what type(s) a given function will work with, but it can at least tell us when we get it wrong.

To fix this properly, we need to do some extra work, telling the `ctypes` library what the argument and return types for each function are. For a more complex library, there will probably be more housekeeping to do, such as translating return codes from functions into more Pythonic-style errors.

For a small example like this there isn’t much of a problem, but the bigger your compiled library the more extra boilerplate is required on the Python side just to use all the functions. When you’re working with an existing library you don’t have much choice about this, but if you’re building it from scratch specifically to interface with Python, there’s a better way using the Python C API. You can call this directly in Rust, but there are a couple of Rust crates that make life much easier, and I’ll be taking a look at those in a future blog post.
