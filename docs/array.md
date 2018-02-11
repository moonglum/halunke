---
title: Array
---

In Halunke arrays are collections of objects. The objects do not
need to be of the same class. Arrays are sorted. They are
surrounded by square brackets. The items are separated by
whitespace.

```
["a" 1 "b"]
[
  "a"
  5
]
```

It can answer to the following messages:

## `=`

Compares to arrays. If they have the same length and each item from
the first array returns true on the `=` message for the according
item from the second list, it returns true. Otherwise, it returns
false. This can also be used to destructure an array.

**Example:**

```
(["a" 1] = ["a" 1]) /* => true */

(['a 2] = [1 2]) /* => true */
/* a is now 2 */
```

## `map`

Calls the provided function for each element. Returns a new array of the same
length with the results of the function calls.

**Example:**

```
([0 1 2] map { |'x| (x + 1) }) /* => [1 2 3] */
```

## `to_s`

This returns a string to represent the array in output.

**Example:**

```
([0 1 2] to_s) /* => "0\n1\n2" */
```

## `inspect`

This returns a string to represent the array for debugging.

**Example:**

```
([0 1 2] inspect) /* => "[0 1 2]" */
```
