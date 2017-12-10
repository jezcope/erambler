---
title: "Recursive Circus — Ruby — #adventofcode Day 7"
description: "In which I go full object-oriented in Ruby."
slug: day-07
date: 2017-12-10T19:04:36+00:00
tags:
- Technology
- Learning
- Advent of Code
- Ruby
series: aoc2017
---

[Today's challenge](http://adventofcode.com/2017/day/7) introduces a set of processes balancing precariously on top of each other. We find them stuck and unable to get down because one of the processes is the wrong size, unbalancing the whole circus. Our job is to figure out the root from the input and then find the correct weight for the single incorrect process.

[→ Full code on GitHub](https://github.com/jezcope/aoc2017/blob/master/07-recursive-circus.rb)

!!! commentary
    So I didn't really intend to take a full polyglot approach to Advent of Code, but it turns out to have been quite fun, so I made a shortlist of languages to try. Building a tree is a classic application for object-orientation using a class to represent tree nodes, and I've always liked the feel of [Ruby](https://www.ruby-lang.org/en/)'s class syntax, so I gave it a go.

First make sure we have access to `Set`, which we'll use later.

```ruby
require 'set'
```

Now to define the `CircusNode` class, which represents nodes in the tree. `attr :s` automatically creates a function `s` that returns the value of the instance attribute `@s`

```ruby
class CircusNode
  attr :name, :weight

  def initialize(name, weight, children=nil)
    @name = name
    @weight = weight
    @children = children || []
  end
```

Add a `<<` operator (the same syntax for adding items to a list) that adds a child to this node.

```ruby
  def <<(c)
    @children << c
    @total_weight = nil
  end
```

`total_weight` recursively calculates the weight of this node and everything above it. The `@total_weight ||= blah` idiom caches the value so we only calculate it once.

```ruby
  def total_weight
    @total_weight ||= @weight + @children.map {|c| c.total_weight}.sum
  end
```

`balance_weight` does the hard work of figuring out the proper weight for the incorrect node by recursively searching through the tree.

```ruby
  def balance_weight(target=nil)
    by_weight = Hash.new{|h, k| h[k] = []}
    @children.each{|c| by_weight[c.total_weight] << c}

    if by_weight.size == 1 then
      if target
        return @weight - (total_weight - target)
      else
        raise ArgumentError, 'This tree seems balanced!'
      end
    else
      odd_one_out = by_weight.select {|k, v| v.length == 1}.first[1][0]
      child_target = by_weight.select {|k, v| v.length > 1}.first[0]
      return odd_one_out.balance_weight child_target
    end
  end
```

A couple of utility functions for displaying trees finish off the class.

```ruby
  def to_s
    "#{@name} (#{@weight})"
  end

  def print_tree(n=0)
    puts "#{'    '*n}#{self} -> #{self.total_weight}"
    @children.each do |child|
      child.print_tree n+1
    end
  end

end
```

`build_circus` takes input as a list of lists `[name, weight, children]`. We make two passes over this list, first creating all the nodes, then building the tree by adding children to parents.

```ruby
def build_circus(data)
  all_nodes = {}
  all_children = Set.new

  data.each do |name, weight, children|
    all_nodes[name] = CircusNode.new name, weight
  end

  data.each do |name, weight, children|
    children.each {|child| all_nodes[name] << all_nodes[child]}
    all_children.merge children
  end

  root_name = (all_nodes.keys.to_set - all_children).first
  return all_nodes[root_name]
end
```

Finally, build the tree and solve the problem! Note that we use `String.to_sym` to convert the node names to symbols (written in Ruby as `:symbol`), because they're faster to work with in `Hash`es and `Set`s as we do above.

```ruby
data = readlines.map do |line|
  match = /(?<parent>\w+) \((?<weight>\d+)\)(?: -> (?<children>.*))?/.match line
  [match['parent'].to_sym,
   match['weight'].to_i,
   match['children'] ? match['children'].split(', ').map {|x| x.to_sym} : []]
end

root = build_circus data

puts "Root node: #{root}"

puts root.balance_weight
```
