---
layout: post
title: One fewer keystroke per statement
description: Lit v0.2.0 released
date: 2025-04-25 22:15 -0300
slug: lit-v0-2-0-released
---

Hey! It's been only a few days since last release, but I just couldn't stop
working on Lit. So here's a new release, and it's packed with stuff I wanted
since forever. The new features are:

## One fewer keystroke per statement

Semicolons aren't required anymore! You can now write:

```lit
println "Hello, world!" # no semicolon here
```

Semicolons are still allowed, just not required.

## Treat primitives as instances

Now it's possible to call methods on primitive types like numbers and strings.
For example:

```lit
println 65.chr?() # "A"

let s = "abc"
println s.empty?() # false
println s.size() # 3
println s.chars() # ["a", "b", "c"]
```

## Add function literals (anonymous functions)

You can now create functions without naming them. This is useful for passing
functions as arguments to other functions. For example, you can now write:

```lit
let add = fn { |a, b| return a + b; }
println add(1, 2); # 3
```

## Operator overloading

You can now overload operators on custom types. Here's a list of the currently
supported operators and the methods you need to implement in your type to
overload them:

| Operator | Method to implement |
| --## | --## |
| unary ## | neg |
| + | add |
| ## | sub |
| * | mul |
| / | div |
| % | mod |
| == | eq |
| != | neq |
| < | lt |
| <= | lte |
| > | gt |
| >= | gte |
| [] | get |
| []= | set |
| stringify (i.e. `println`) | to_s |

Check out [this example] to see how to overload operators on custom types.

[this example]: https://github.com/lit-lang/lit/blob/a90eec865a6ca1ac850dc6f6fedf8b5cd7c3d955/spec/e2e/custom_types/operator_overload.lit

## `else if`

Add an `else if` syntax sugar to the `if` statement. Now you can write:

```lit
if a == 1 {
    println "a is 1"
} else if a == 2 {
    println "a is 2"
} else {
    println "a is neither 1 nor 2"
}
```

This is equivalent to:

```lit
if a == 1 {
    println "a is 1"
} else {
    if a == 2 {
        println "a is 2"
    } else {
        println "a is neither 1 nor 2"
    }
}
```

## Add `Map` type

A map, also known as a dictionary or hash table, is a collection of key-value
pairs.

```lit
let m = Map();
m.set("a", 1);
m.set("b", 2);
println m.get("a"); # 1
println m.get("b"); # 2
println m.get("c"); # nil
println m.merge(Map("a", 2)) # Map("a" => 2, "b" => 2)
```

## Allow `fn` keyword before method definitions

In the past, you could not use the `fn` keyword before method definitions. Now
you can:

```lit
type Foo {
  # this wasn't allowed before
  fn bar { println "bar"; }

  # this was allowed before and still works. I might deprecate it in the future
  baz { println "baz"; }
}
```

## Change default string representation for instances of custom types

Before, instances had the not very helpful "<type> instance" string
representation. Now, they'll list their types and fields.

```lit
type User {
  init { |name, age|
    self.name = name
    self.age = age
  }
}

println User("Alice", 30) # User(name: "Alice", age: 30)
```

## New stdlib functions

`sleep`, `argv`, `exit`, `panic`, `eprint`, `eprintln`, and `measure` were added.

## Next up

I know most of these changes are syntax-related, but I want Lit to _feel_ right
as a scripting language. The language isn't super powerful yet, so I've been
writing only small scripts with it. It is also super slow, but I don't care
about that yet.

As for the next release, I don't have a plan for the next release, but I'd love
to remove (or greatly reduce) the statements in the lang. Blocks need to be
expressions, as well as ifs. println/print should not be keywords, but rather
functions. Maybe a syntax for array and map literals? Stay tuned!
