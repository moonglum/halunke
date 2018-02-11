---
title: String
---

In Halunke strings are used to represent all kinds of text
including single characters. They are surrounded by double quotes
(single quotes are not allowed).

```
"Foo Bar"
```

It can answer to the following messages:

## `reverse`

Return a reversed version of the String.

**Example:**

```
("hello" reverse) /* => "olleh" */
```

## `replace with`

Replace all occurrences of the first string with the second string.

**Example:**

```
("ababab" replace "a" with "c") /* => "cbcbcb" */
```

## `=`

This compares two strings. It is true, if the two strings are equal. Otherwise,
it is false.

**Example:**

```
("aaa" = "aaa") /* => true */
```

## `+`

Concatenate two strings.

**Example:**

```
("aaa" + "bbb") /* => "aaabbb" */
```

## `to_s`

This returns the string itself.

**Example:**

```
("aaa" to_s) /* => "aaa" */
```

## `inspect`

This returns a string to represent the string in output. This is done by surrounding it with `"`

**Example:**

```
("aaa" inspect) /* => "\"aaa\"" */
```
