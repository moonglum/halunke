---
title: Dictionary
---

In Halunke, dictionaries are collections of objects that map values
to other values. The first entry is the key for the second entry,
the third for the fourth etc. (the number of elements is therefore
always even). Like in a real dictionary, you can then look them up
Like in a real dictionary, you can then look them up. They are
written in square brackets, prefixed with an `@`.

```
@["a" 1 "b" 2]
```

It has an alternative constructor to construct it from an array of
two element arrays:

```
(Dictionary from [["a" 1] ["b" 2]])
/* => @["a" 1 "b" 2] */
```

It can answer to the following message:

## `@ else`

Looks up a value in the dictionary. If the key is not in the
dictionary, the fallback value is used.

**Example:**

```
(@["a" 1 "b" 2] @ "a" else "Not Found") /* => 1 */
(@["a" 1 "b" 2] @ "c" else "Not Found") /* => "Not Found" */
```

## `to_s`

This returns a string to represent the dictionary in output.

**Example:**

```
(@["a" 1 "b" 2] to_s) /* => "a 1\nb 2" */
```

## `inspect`

This returns a string to represent the dictionary for debugging.

**Example:**

```
(@["a" 1 "b" 2] inspect) /* => "@[\"a\" 1 \"b\" 2]" */
```
