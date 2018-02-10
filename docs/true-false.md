---
title: True & False
---

In Halunke `true` is an instance of the `True` class, and `false`
is an instance of the `False` class. They are used to realize
boolean operations (for example `and`) as well as for branching.
They answer to the same messages. So you could use it like this:

```
((5 > 3) then { "yes!" } else { "no!" })
/* Returns "yes!" */
```

## `and`

Returns true if both the receiver as well as the provided value are
true.

**Example:**

```
((5 > 3) and (2 < 1)) /* => false */
```

## `or`

Returns true if either the receiver or the provided value are true.

**Example:**

```
((5 > 3) or (2 < 1)) /* => true */
```

## `then else`

If the receiver is true, it will execute the first branch. If it is
false, it will return the second branch.

**Example:**

```
(true then { "yes" } else { "no" }) /* => "yes" */
(false then { "yes" } else { "no" }) /* => "no" */
```

## `inspect`

This returns a string to represent true and false in output.

**Example:**

```
(true inspect) /* => "true" */
(false inspect) /* => "false" */
```
