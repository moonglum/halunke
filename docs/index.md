---
layout: default
title: Welcome to Halunke!
---

<p align="center"><img src="/img/halunke-logo.png" alt="Halunke" width="600px" /></p>

Halunke is a dynamic, object-oriented language that has a simple grammar
inspired by Smalltalk and Lisp. It is created to show that interesting
characteristics traditionally described as "functional" make sense in an
object-oriented language:

* Separation of identity and data (but not data and behavior)
* Immutability and persistent data structures
* Isolation of Side-Effects
* Pattern matching

It also has the following characteristics:

* There is no null/nil value in the language
* Playing close attention to error message design

## Install & Usage

Halunke is written in Ruby, and can be installed with:

```
gem install halunke
```

You can start a REPL with `halunke` or run a file with `halunke file.hal`.

Alternatively (if you don't have Ruby installed for example), you
can run it with Docker:

```
docker run --rm -ti moonglum/halunke
```

## How it works

In Halunke, everything is an object. And you can send messages to Objects.

```
(1 + 2)
```

`1` and `2` are both objects. You can send a message to an object by using
parentheses: You first provide the name of the receiver followed by a message.
In this case you send the message `+` to `1` with the value [`2`]. It will
return the object `3`.

You can also send a message without any value. An example for that would be to
reverse a string:

```
("Halunke!" reverse)
```

This will return `"!eknulaH"`. If you want to provide more than one value, it
works like this:

```
("Halunke!" replace "Ha" with "Spe")
```

This will return `"Spelunke!"`. The message we send here is `replace with` and
the value is `["Ha" "Spe"]`.

If you want to find out more about the types of objects in Halunke
and the messages you can send to them, explore the navigation bar
at the top. If you want to learn more about conditionals, check out
the section about [True & False](/halunke/true-false). If you want
to write your own functions, check out
[Function](/halunke/function) and if you want to define your own
classes, check out [Class](/halunke/class).

If you want to store an object in a variable, you can do it like this:

```
('a = 12)
```

Now you can send messages to `a` like `(a + 2)`. Why is there a `'` though? The
`'` signals an unassigned bareword. That means you can send it a `=` message
with a value, and it will assign it. Be aware that you can't reassign. So if
you assign something to a once, it will stay like this forever (within that
scope). Reassigning will result in an error. *There will be reassignable
references in the future, see [the issue for
details](https://github.com/moonglum/halunke/issues/3)*

The values are also immutable. If you send a message to an object,
it will not change the object, but it will return an answer to you.

Comments are written between `/*` and `*/`. They can be multiline.
