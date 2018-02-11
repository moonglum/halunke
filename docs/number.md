---
title: Number
---

In Halunke all numbers are rational. You write them as decimal numbers:

```
2
-3
2.12
```

It can answer to the following messages:

## `+`

This adds two numbers.

**Example:**

```
(0.6 + 0.3) /* => 0.9 */
```

## `-`

This subtracts two numbers.

**Example:**

```
(0.6 - 0.3) /* => 0.3 */
```

## `/`

This divides two numbers.

**Example:**

```
(0.6 / 0.3) /* => 2 */
```

## `*`

This multiplies two numbers.

**Example:**

```
(0.6 * 0.3) /* => 0.18 */
```

## `<`

This compares two numbers. It is true, if the first number is smaller than the
second number. Otherwise, it is false.

**Example:**

```
(0.6 < 0.3) /* => false */
```

## `>`

This compares two numbers. It is true, if the first number is greater than the
second number. Otherwise, it is false.

**Example:**

```
(0.6 > 0.3) /* => true */
```

## `=`

This compares two numbers. It is true, if the two numbers are equal. Otherwise,
it is false.

**Example:**

```
(0.6 = 0.3) /* => false */
```

## `to_s`

This returns a string to represent the number in output.

**Example:**

```
(0.6 to_s) /* => "0.6" */
```

## `inspect`

This returns a string to represent the number for debugging.

**Example:**

```
(0.6 inspect) /* => "0.6" */
```
