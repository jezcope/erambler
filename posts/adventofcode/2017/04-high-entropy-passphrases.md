---
title: "High Entropy Passphrases — Python — #adventofcode Day 4"
description: "In which I act as the local password inspector."
slug: day-04
date: 2017-12-05T21:18:20+00:00
tags:
- Technology
- Learning
- Advent of Code
- Python
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/4) describes some simple rules supposedly intended to enforce the use of secure passwords. All we have to do is test a list of passphrase and identify which ones meet the rules.

[Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/04-high-entropy-passphrases.py)

!!! commentary
    Fearing that today might be as time-consuming as yesterday, I returned to Python and it's hugely powerful "batteries-included" standard library. Thankfully this challenge was more straightforward, and I actually finished this before finishing [day 3](../day-03/).
    
First, let's import two useful utilities.

```python
from fileinput import input
from collections import Counter
```

Part 1 requires simply that a passphrase contains no repeated words. No problem: we split the passphrase into words and count them, and check if any was present more than once.

`Counter` is an amazingly useful class to have in a language's standard library. All it does is count things: you add objects to it, and then it will tell you how many of a given object you have. We're going to use it to count those potentially duplicated words.

```python
def is_valid(passphrase):
    counter = Counter(passphrase.split())
    return counter.most_common(1)[0][1] == 1
```

Part 2 requires that no word in the passphrase be an *anagram* of any other word. Since we don't need to do anything else with the words afterwards, we can check for anagrams by sorting the letters in each word: "leaf" and "flea" both become "aefl" and can be compared directly. Then we count as before.

```python
def is_valid_ana(passphrase):
    counter = Counter(''.join(sorted(word)) for word in passphrase.split())
    return counter.most_common(1)[0][1] == 1
```

Finally we pull everything together. `sum(map(boolean_func, list))` is a common idiom in Python for counting the number of times a condition (checked by `boolean_func`) is true. In Python, `True` and `False` can be treated as the numbers 1 and 0 respectively, so that summing a list of Boolean values gives you the number of `True` values in the list.

```python
lines = list(input())
print(sum(map(is_valid, lines)))
print(sum(map(is_valid_ana, lines)))
```

