---
title: Stdio
---

The object `stdio` is available from everywhere. *This will change in the
future. Interacting with STDIO is IO and will be isolated.*

## `puts`

Prints the object to stdout. To determine how to represent the object, it will
send the `to_s` message to the object, expecting a string.

**Example:**

```
(stdio puts "Hello World")
(stdio puts 5.2)
(stdio puts @["a" 2 "b" 3])
(stdio puts ["a" "b"])
(stdio puts true)
(stdio puts false)
```

This will output:

```
Hello World
5.2
a 2
b 3
a
b
true
false
```

## `p`

Prints the object to stdout for debugging. To determine how to represent the
object, it will send the `inspect` message to the object, expecting a string.

**Example:**

```
(stdio p "Hello World")
(stdio p 5.2)
(stdio p @["a" 2 "b" 3])
(stdio p ["a" "b"])
(stdio p true)
(stdio p false)
```

This will output:

```
"Hello World"
5.2
@["a" 2 "b" 3]
["a" "b"]
true
false
```
