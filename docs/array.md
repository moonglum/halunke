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

## `@ else`

Looks up a value in the Array by index. If the index is out of
bounds for the array, return the fallback value

**Example:**

```
([2 3 4] @ 1 else "NOT FOUND") /* => 3 */
([2 3 4] @ 3 else "NOT FOUND") /* => "NOT FOUND" */
```

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

## `reduce with`

Combines all elements of the array into a single element. The second argument
is the initial value of the memo variable. The function will be called once
for each of the elements. The first argument is the memo, the second the current
element. The result of each iteration will be the memo for the next call.
The final value of memo will be returned.

```
([1 2 3] reduce {|'memo 'el| (memo + el) } with 0)
/* => 6
```

## `find else`

Calls the provided function for each element. Returns the first element for
which the function returns true. If none of the calls returns true, it will
return the fallback value.

**Example:**

```
(["a" "b" "c"] find { |'el| (el = "a") } else "not found")
/* => "a" */
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
