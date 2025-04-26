---
layout: post
title: Hello Lit — Or, if you squint, it's Lox
description: Lit v0.1.0 released
date: 2025-04-16 15:01 -0300
slug: hello-lit
---

[Almost exactly 5 years ago][], I started reading [Crafting Interpreters][] and
creating my own programming language. It went for a while, I gave it a new name,
[changed repos][repo], stopped working on it, and then I eventually came back.
I've decided to release _something_, so here's the [v0.1.0 of Lit][release], a
safer scripting language _(eventually)_.

## What is Lit?

Lit is a dynamically typed, scripting language that aims to be safer than the
usual ones. You can check more details on the [main page](/#error-handling). But the gist is that it
will have a minimalistic type system that, if I do it right, will be basically
invisible to you, while providing a safer experience.

## What's in v0.1.0?

Because it was created while reading the book, [Lit v0.1.0][release] is
basically the Lox language, with a few changes. Whenever possible, I change the
syntax to what I envisioned for the language, or something close to that. Lit
will evolve and get more and more different from Lox in the future. Here's a
list of the main differences now.

### Features

- Arrays are supported

```lit
let a = Array(1, 2, 3);
println a.get(0); # 1
a.set(0, 4);
println a; # [4, 2, 3]
a.push(5);
pritnln a.size(); # 4
```

- String interpolation

```lit
let who = "world";
println "Hello, {who}!";
```

- Pipeline operator `|>`

```lit
fn double { |x| return x * 2; }
fn difference { |a, b| return a - b; }

# pipes lhs to first argument of rhs
println 10 |> double() |> difference(1); # 19
```

- The `let` keyword to create immutable bindings

```lit
let x = 1;
x = 2; # error!
```

- The `until` keyword for creating loops that run until a condition is met
- The `loop` keyword for creating infinite loops
- The `break` and `next` keywords are supported for loops

```lit
var i = 0;
loop {
  if i == 10 { break; }
  println i;
  i = i + 1;
}
```

- Nested multi-line comments

```lit
#= Multi-line comments
  #=
    can be nested
  =# still a comment
=# "not here"
```

- Numbers can have underscores in them

```lit
println 1_234_567; # 1234567
println 1_234.567; # 1234.567
println 1.234_567; # 1.234567
println 1_234.567_890; # 1234.56789
println 1_2_3; # 123
```

- A few extra native functions (`typeof`, `readln`, `open`)
- Minor syntax differences (if, while, function definitions, class definitions).

### Anti-features

No inheritance :)

## The future

I'll keep working on Lit and I'll try to make regular releases. I haven't
decided the frequency yet. I don't have a set roadmap, but I have [several
ideas]. I'll probably tackle them as my interest goes. Not a promise, but I'll
try removing the required semicolons and required `return`s in the next release!
I'll also try making Lit powerful enough to parse itself, so we can build stuff
like linters and formatters in Lit itself.

That's it for today. Thanks for reading! If you want to try it out, you can find
the code on [GitHub][repo].

[Almost exactly 5 years ago]: https://github.com/MatheusRich/cryox/commit/02bfbcd1609ccffcb2b67a41bb3391b106d57372
[Crafting Interpreters]: https://craftinginterpreters.com/
[repo]: https://github.com/lit-lang/lit
[several ideas]: https://github.com/lit-lang/lit/issues
[release]: https://github.com/lit-lang/lit/releases/tag/v0.1.0
