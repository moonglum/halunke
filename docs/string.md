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

Replace all occurrences of the first string with the second string. You can
also provide a Regexp as the first argument. You can then use backreferences in
the `with` String: The entire match can be referenced by `\0`, the first group
by `\1` etc,

**Examples:**

```
("ababab" replace "a" with "c") /* => "cbcbcb" */

("ababab" replace (Regexp from "(a)") with "<\1>")
/* => "<a>b<a>b<a>b" */
```

## `match`

This matches a Regexp over a String an collects the results in a Dictionary.
The entire match is available under the key 0. Every named match can be
referenced by its position starting from 1. And all named matches can be
referenced by their name and their position.

```
('regexp = (Regexp from "(?<foo>a+)b(?<bar>c+)"))
('match = ("aaaabcc" match regexp))

(match @ 0 else "NOT FOUND") /* => "aaaabcc" */
(match @ 1 else "NOT FOUND") /* => "aaaa" */
(match @ 2 else "NOT FOUND") /* => "cc" */
(match @ "foo" else "NOT FOUND") /* => "aaaa" */
(match @ "bar" else "NOT FOUND") /* => "cc" */
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
