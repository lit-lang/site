---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<div class="Logo mx-auto">
  <img src="https://raw.githubusercontent.com/lit-lang/lit/refs/heads/main/assets/icon-square.png" alt="Lit logo">
  <h1>Lit</h1>
<!-- [Repository](https://github.com/lit-lang/lit) -->
</div>

Lit is a simple scripting language.

```rb
fn factorial_of { |n|
  if n <= 1 { return 1; }

  n * factorial_of(n - 1);
}

if let n = readln.to_n!() {
  println "Factorial of {n} is {factorial_of(n)}";
} else {
  println "Not a valid number"
}
```

## Getting Started

To use Lit, you'll have to build it from source. It is build using
[Crystal](https://crystal-lang.org/), so you'll need to have that installed first.

1. Install Crystal
2. Build Lit
    1. Clone the repository `git clone https://github.com/lit-lang/lit`
    2. Change into the directory `cd lit`
    3. Build the project `tools/build`. This will create an executable at `bin/lit`
3. Run a script with `bin/lit hello.lit` or `bin/lit` to enter the REPL.

## Syntax

### Comments

Comments can appear at the end of a line or span multiple lines.

```rb
# Single-line comments

#= Multi-line comments
  #=
    can be nested
  =#
=#
```

### Literals

Lit has a few basic literal types: numbers, strings, booleans.

#### Numbers

```rb
1         # all numbers are floats
1.5
1_000_000 # underscores are allowed
0.000_1   # even on the decimal side
```

#### Strings

```rb
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

### Booleans

```rb
true
false
```

### Operators

Lit supports a variety of operators for different operations.

```rb
-1         # negation
1 + 2      # addition
1 - 2      # subtraction
1 * 2      # multiplication
1 / 2      # division
1 % 2      # modulus
1 > 2      # comparison
1 < 2
1 >= 2
1 <= 2
1 == 2
```

- Boolean: `and`, `or`, `not` (or symbolic if preferred)

### Variables

- `let` for immutables
- `mut` for mutables
- Variable naming style (e.g. kebab-case)

### Functions

- How to define functions (`fn greet { |name| println("Hi #{name}") }`)
- Implicit return of last expression
- Using blocks as function bodies
- `it` as the default block parameter

### Control Flow

- `if` with `do`
- Block-style conditionals
- `if`/`else`, `unless` (if you support it)
- `while`, `for`, etc (if supported)

### Blocks & Scoping

- Blocks are expressions
- `{1 + 2} * 3` and `do` syntax
- Returning last value
- Using blocks in method chains

### Method Calls / Attribute Access

- The `/` operator: `user/name/upcase`
- How it chains
- Dotless, readable design

###  Collections & Iteration

- How to create lists, maps
- `each`, `map`, etc: `users/each { println it }`
- How blocks interact with collections

###  Pattern Matching / Destructuring

- Tuple unpacking
- Destructuring assignment
- Match expressions

###  Modules / Imports

- How to organize code across files

###  Errors / Exceptions

- How to handle runtime errors
