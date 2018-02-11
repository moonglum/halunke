---
title: Function
---

This is how you define a function:

```
('fn = { |'a 'b| (a + b) })
```

This is a function that expects two arguments. Functions in Halunke are
Objects. If you want to invoke a function, you send them the `call` message
with an array with the arguments (in our case two):

```
(fn call [1 2])
/* => 6 */
```
