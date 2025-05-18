---
layout: default
---

<h1 class="sr-only">The Lit Programming Language</h1>

Lit is a simple scripting language.

```lit
fn factorial_of { |n|
  if n <= 1 do return 1

  n * factorial_of(n - 1)
}

if let n = readln().to_i!() {
  println "Factorial of {n} is {factorial_of(n)}"
} else {
  println "Not a valid number"
}
```

I build it for fun while reading [Crafting
Interpreters](https://craftinginterpreters.com/). This site is more or less my
*vision* for the language. Nothing is set in stone yet, and not all features are
implemented.

## Getting Started

To use Lit, you'll have to build it from source. It is build using
[Crystal](https://crystal-lang.org/), so you'll need to have that installed first.

1. Install Crystal
2. Build Lit
    1. Clone the repository `git clone https://github.com/lit-lang/lit`
    2. Change into the directory `cd lit`
    3. Build the project `tools/build`. This will create an executable at `bin/lit`
3. Run a script with `bin/lit hello.lit` or `bin/lit` to enter the REPL.

<aside>
  <strong>⚠️ WIP</strong>
  <p>Lit is <em>extremely</em> early-days, so not all features are implemented yet.</p>
</aside>

## Syntax

### Comments

Comments can appear at the end of a line or span multiple lines.

```lit
# Single-line comments

#= Multi-line comments
  #=
    can be nested
  =# still a comment
=# "not here"
```

### Literals

Lit has a few basic literal types: integers, floats, strings, booleans,
functions, arrays, and maps.

#### Numbers

```lit
1         # integer
1.0       # float
1_000_000 # underscores are allowed
0.000_1   # even on the decimal side
```

#### Strings

```lit
# double-quoted strings can contain interpolation
"Hello, {"world"}"

# double-quoted strings can contain escape sequences
"I can\tescape\ncharacters"

# single-quoted strings are raw
'Hello, {"world"}'
'I will not escape \n characters'

# short-hand for single-quoted strings
:hey == 'hey' # => true
```

Strings support these escape codes:

- `\n`: newline
- `\t`: tab
- Any other character prefixed with `\`: that character

#### Booleans

In Lit, only `false` and [errors](#error-handling) are falsey. Everything else
is truthy.

```lit
println true && 0 && "" && fn {} && [] && {:} && "Truthy" # "Truthy"
println false  || "Falsey" # "Falsey"
```

#### Arrays

Arrays are ordered lists of values.

```lit
let arr = [1, 2, 3,] # trailing comma is allowed

# You can access elements in an array using the `[]` operator
arr[0] # => 1

# Use `[]=` to set an element in an array:
arr[0] = 4
println arr # => [4, 2, 3]
```

#### Maps

Maps are key-value pairs (separated by a colon), also known as dictionaries or
hashes in other languages.

```lit
# Create a map
let user = {
  "name" : "Yukihiro Matsumoto",
  "role" : "creator", # trailing comma is allowed
}

# Access a value in a map
user["name"] # => "Yukihiro Matsumoto"

# Set a value in a map
user["name"] = "Matz"
println user # => {"name" : "Matz", "role" : "creator"}

# An empty map
let empty_map = {:}

{x: 0, y: 0} # same as {"x" : 0, "y" : 0}
```

#### Functions

```lit
# Function definition
fn greet { |name| println "Hello, {name}" }

# Function call
greet("Matz") # outputs "Hello, Matz"

# Named functions **aren't** closures
let name = "Matz"
fn greet { println "Hello, {name}" } # error: 'name' is not defined

# Anonymous functions are closures
let name = "Matz"
let greet = fn { println "Hello, {name}" } # outputs "Hello, Matz"

# The default block parameter is `it`
fn greet { println "Hello, {it}" }
greet("Matz") # outputs "Hello, Matz"

# Functions return the last expression
fn fun {
  false
  "something"
  1
}
fun() # => 1

# you can use `return` to return early
fn fun { |value|
  if value {
    return "truthy"
  }

  "falsey"
}
fun(true)  # => "truthy"

# you can create anonymous functions:

[1, 2, 3].map(fn { |x| x * 2 }) # => [2, 4, 6]
```

### Variables

You can declare variables using `let` or `var`. Variables are scoped to the block
they are defined in. You can use `let` for immutable bindings and `var` for
mutable bindings.

```lit
let x = 1
x = 2 # error: cannot assign to immutable variable

var y = 1
y = 2 # ok
```

- Variable naming style (e.g. kebab-case)

### Operators

Lit supports a variety of operators for different operations.

```lit
-1           # negation
1 + 2        # addition
1 - 2        # subtraction
1 * 2        # multiplication
1 / 2        # division
1 % 2        # modulus
1 > 2        # comparison
1 < 2
1 >= 2
1 <= 2
1 == 2
```

These operators can be overloaded on custom types. See [Operator
Overloading](#operator-overloading) for more details.

- Boolean: `and`, `or`, `not` (or symbolic if preferred)

### Control Flow

- `if` with `do`
- Block-style conditionals
- `if`/`else`,
- `while`/`until`

### Blocks & Scoping

- Blocks are expressions
- The last expression in a block is the return value.

Because of that, you can use blocks to change the order of operations.

```lit
{1 + 2} * 3
# => 9
```

For a single-expression body, you can use the `do` syntax:

```lit
fn debug do println("DEBUG: " + it)
```

### Pattern Matching / Destructuring

- Destructuring assignment
- Match expressions

### Custom Types

Lit supports custom types using the `type` keyword. Types are composed of one or
more `variant`s. Each variant defines a constructor with fields and optional
methods. Fields and methods are public by default unless their name starts with
an underscore `_`.

#### Defining a Type

To define a type with a single variant, use the following syntax:

```lit
type Point { |x, y|
  fn to_s { "({x}, {y})" }
}

let origin = Point(0, 0)
println origin # outputs "(0, 0)"
```

#### Multiple Variants

Types can have multiple variants, each representing a different shape or case.
This is useful for enums, tagged unions, or sum types.

```lit
type Shape {
  variant Circle { |radius|
    fn area { 3.14 * radius * radius }
  }

  variant Square { |side|
    fn area { side * side }
  }

  fn kind {
    match self {
      Circle then "circle"
      Square then "square"
    }
  }
}

let s1 = Shape.Circle(5)
println s1.kind() # outputs "circle"
println s1.area() # outputs "78.5"

let s2 = Shape.Square(3)
println s2.kind() # outputs "square"
println s2.area() # outputs "9"
```

#### Field and Method Visibility

Fields are only directly accessible inside the variant block. Fields starting
with `_` are private and cannot be matched.

Methods starting with `_` are private and cannot be called from outside the type
declaration.

```lit
type User { |name, _password|
  fn check_password do it == _password # please don't use this in production
  fn _debug { println "user={name}" }
}

let user = User("alice", "secret")

match user {
  Account { |name, _password| #= body =# }        # error: _password is private
}

user.check_password("guess")   # => false
user._debug()                  # error: _debug is private
```

#### Operator Overloading

Lit supports operator overloading for custom types. You can define how
operators behave for your custom types by implementing the corresponding
methods. Here's a list of the currently supported operators and the methods you
need to implement in your type to overload them:

| Operator | Method to implement |
|:-:|:-:|
| unary - | neg |
| + | add |
| - | sub |
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

### Modules / Imports

- How to organize code across files

### Collections & Iteration

- Implementing iteration for custom types with

### Error Handling

- How to handle dangerous operations

<div id="table-of-contents">
  {{ page.content | toc_only }}
</div>
