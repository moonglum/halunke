---
title: Class
---

In Halunke, Classes are objects. They consist of a dictionary that
maps message names to functions. Objects are a wrapper around a
dictionary. The dictionary contains the attributes of the object.
The object knows its class, and when messages are send to the
object, it will look up the according function in its class and
call it.

Classes are created by sending a message to the Class object. One
of these messages is `new attributes methods`. Let's create a
class:

```
(Class new 'Counter
    attributes ["value"]
    methods @[
        "value" { |'self|
            (self @ "value" else 0)
        }
    ]
)
```

To create an instance of the class, we send the `new` message to
the class with a dictionary that represents the attributes:

```
('counter = (Counter new @["value" 0]))
```

Now we can send the `value` message to our counter, and we will
receive 0:

```
(counter value)
```

In our class definition, we first gave an array of attributes. You
can imagine it as kind of whitelist for attributes: The attribute
dictionary you pass to new can only have keys that are on this
list. Now let's look at the function that is called when you send
the value message:

```
{ |'self| (self @ "value" else 0) }
```

Every function that is used as a method receives the object itself
as its first argument. This can be used to send messages to the
object itself. Each object can receive the `@ else` message. This
is used to look up attributes in the dictionary. Our function
therefore returns the value attribute or 0, if it was not set.

Now let's add a method to increase the counter. Remember that objects
are immutable. So we need to return a new counter with the value
that is one higher than our current value:

```
"increase" { |'self|
    (Counter new @["value" ((self value) + 1)])
}
```

We can use it like this:

```
('counter = (Counter new @["value" 0]))
('increased_counter = (counter increase))
```

The `'increased_counter` will return `1` as its value.

Now you might want to have a custom constructor that needs less typing and is
more expressive. You can do that by introducing a class method that calls the
`new` method. Class methods receive the class as the first parameter.

```
(Class new 'Counter
    attributes ["value"]
    methods @[
      "value" { |'self|
          (self @ "value" else 0)
      }
      "increase" { |'self|
          (Counter new @["value" ((self value) + 1)])
      }
    ]
    class_methods @[
      "from" { |'self 'value|
        (self new @["value" value])
      }
    ]
)
```

Now we can create a counter like this:

```
('counter = (Counter from 5))
```
