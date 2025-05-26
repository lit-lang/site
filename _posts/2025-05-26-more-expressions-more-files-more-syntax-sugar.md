---
layout: post
title: More expressions. More files. More syntax sugar.
date: 2025-05-26 13:45 -0300
description: Lit v0.3.0 released
slug: lit-v0-3-0-released
---

Hello, world! It's been a month since the last release. I didn't want to release
a new version right now, but the changes were piling up. Lit v0.3.0 is here, and
it brings a lot of new features.

## New syntax

- Arrays and maps can be defined using the new literal syntax:

```lit
let array = [1, 2, 3]
println(array[0]) # 1

let key3 = 3
let map = {
  "key1" : "value1",
  key2: "value2", # shorthand syntax for string keys
  key3 : "three"
}
println(map["key2"]) # value2

let empty_map = {:} # empty map
```

- Add symbol strings

Symbol strings are just a different syntax for strings. They don't support
interpolation or escaping, but they look prettier in DSLs.

```lit
println(:hey == 'hey' && :hey == "hey") # true
println(:hey) # hey
println(:123) # 123
println(:1a2b3c) # 1a2b3c
```

- Add `do` keyword to define single-line blocks

```lit
if something_true do println("truthy!") # prints "truthy!"

fn log do |what| println("[LOG] {what}")
log("Success!") # expect: [LOG] Success!

# You can use it as an expression, even if it doesn't make much sense
let a = do "Hello"
println(a) # prints Hello
```

It won't work as the body of a `type` or `loop`, as those need to be multi-line
blocks.

- Introduce `it` as default parameter for one-line (do) blocks:

```lit
fn square do it * it

[1, 2, 3].each(fn do println(square(it))) # prints 1\n4\n9
```

It isn't allowed in multi-line blocks as I believe that hurts readability more
than helps. But if you *really* want it, there's a "hack" to do that:

```lit
["me"].each(fn do {
  println("No one can stop {it}!")
})
# prints "No one can stop me!"
```

I might remove this in the future, but for now it works.

- Allow break to return a value

```lit
let x = loop {
  break 1
}
println x # prints 1
```

- Add augmented assignment operators

```lit
let a = 1
a += 2 # a = a + 2
a -= 3 # a = a - 3
a *= 4 # a = a * 4
a /= 5 # a = a / 5
a %= 6 # a = a % 6
```

## Importing files

Lit programs finally can span multiple files! You can now use the `import`
keyword to import other Lit files. They work similar to Ruby's
`require_relative`. There's not module system yet, so all the files imported
this way share the same global scope.

```lit
import "foo" # imports foo.lit from the same directory
import "../bar" # imports bar.lit from the parent directory
```

The error messages now include the file name and line number, so you can find
the source of the error.

This is the first step towards a module system and a proper standard library.

## More expressions

I'm moving Lit towards being an expression-oriented language, so this release
brings a lot of changes to make more constructs expressions instead of
statements. This shift will allow you to remove the need for `return` in
function bodies and use constructs like `if`, `while`, and `loop` as
expressions.

For example, `if` is now an expression rather than a statement. You can assign
its result directly to a variable:

```lit
let value = if true {
  "lucky"
} else {
  "not lucky"
}

println(value) # lucky

# or using do-blocks:

let value2 = if false do "not lucky" else do "lucky"
```

Blocks are also now expressions. This means you can group expressions together
and assign the result, which opens the door to not needing explicit returns in
the future:

```lit
let x = {
  let a = 1;
  let b = 2;
  a + b # no need for return
}

println(x) # 3
```

Similarly, `while`, `until`, and `loop` have become expressions. `while` returns
the last value of their block. Both `while` and `loop` will return the value of
`break` if it is used, or `nil` otherwise.

```lit
println(while false {}) # prints nil

var c = 0
println(
  while c < 2 {
    c = c + 1
    c - 1
  }
) # prints 1

let x = loop {
  let a = 1
  let b = 2
  break a + b # returns 3
}
```

The `return` keyword itself is now an expression, which means you can use it in
one-line blocks:

```lit
fn fib { |n|
  if n <= 1 do return n

  fib(n - 1) + fib(n - 2)
}
```

Even variable declarations with `var` and `let` are now expressions, returning
the value assigned. This enables chaining assignments in a concise way:

```lit
let a = let b = let c = 1
println([a, b, c]) # prints [1, 1, 1]
```

## Breaking changes

There were a few breaking changes in this release, but I'm the only user, so
screw it. Here are the most important ones:

- Only allow setting new fields on initializers

```lit
type Foo {
  init { |x| self.x = x; }
}

let f = Foo(1);
f.x = 2; # Ok
f.y = 3; # Runtime error: Undefined property 'y' for Foo.
```

This helps with encapsulation, and is a step towards the type + variants system
I want to implement in the future.

- Make `println`/`print` functions, not keywords

This is a super breaking change, but the functions at least support multiple
arguments, so that's nice. Now you can use them with the pipeline operator too.

```lit
println "Hello, world!" # doesn't work anymore
print("Hello", ",", " ", "world!", "\n") # this works now
```

- Remove ternary operator.

The ternary operator was removed in favor of the new `if` expression syntax.

## Miscellaneous

- Add `-e`/`--eval` option to CLI

This option allows you to execute some code directly from the command line. For
example:

```sh
lit -e 'println("Hello, world!")'
# Hello, world!
```

- Prevent `break`/`next` from being used in functions inside loops:

```lit
loop {
  fn foo {
    break # Syntax error at "break": Can't use 'break' outside of a loop.
  }
}
```

- Improve REPL

Now it outputs the result of the last expression. It also has colors for the results.

The result of the last expression is stored in the variable `_`.

```lit
lit> 1 + 2
=> 3
lit> _ * 2
=> 6
```

- Compare arrays/maps by structure

```lit
let a = [1, 2, 3]
let b = [1, 2, 3]
println a == b # true

let m = {a: 1, b: 2}
let n = {b: 2, a: 1}
println m == n # true
```

## Next steps

Lit is starting to look like a real language, but there's still plenty of work
ahead. One of my current goals is to build a Lit interpreter in Lit itself. This
has been a fun challenge and a great way to uncover pain points in the language
design.

A module system (or at least a way to group related functions) feels like the next
logical step. I've also put together a basic test framework in Lit, which I'm
now using to test the interpreter. It works, so I might release it as
part of the standard library.

This is a hobby project, so I'll keep focusing on what I find interesting and
fun. Thanks for following along, and see you next time!
