---
title: Web
---

The object `web` is available from everywhere. *This will change in the future.
Interacting with STDIO is IO and will be isolated.*

You can send the `run on` message to `web`. It expects the first object to be
your application (more on that later) and the second one the bind address and
port in the format: `0.0.0.0:3000`.

Your app needs to be an object that can receive the `call` message. It will be
called with the environment dictionary that represents the request. It expects
that your return an array that represents the response.

## Environment Dictionary

The environment dictionary has the following keys:

* `request_method`: The request method in upper case (for example: `"GET"`)
* `path`: The path that was requested (for example: `"/the/path"`)
* `query`: The query part of the request (for example: `"foo=bar&beep=boop"`)

## Response Array

The response array has three elements:

1. The first element is the status code as a String (for example: `"200"`)
2. The second element are the headers as a dictionary (for example: `@[
   "Content-Type" "text/html" ]`)
3. The third element is an array of strings that represent the body (for
   example: `[ "<h1>Halunke!</h1>" ]`)
