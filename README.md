Goal!
=====

Goal! may someday be a Lisp that compiles to Go.

But first we'll build a development environment with a more interactive experience
than the write, compile, run cycle typical of 1970's era programming environments.

We'll start with something simple, perhaps a REPL you can use in Emacs.

There'll be a preprocessor too.  Go is pretty boiler-plate, and there's plenty
of low-hanging fruit.  Consider the common case of a function returning a primary value
and a second error value.  Instead of writing:

````
if x, err := f() ; err != nil {
  complain(err)
} else {
  doit()
}
	  
````
We'd prefer something concise:

````
if! x f() doit() complain(err)
````
*if!* could be an [anaphoric macro](http://en.wikipedia.org/wiki/Anaphoric_macro) providing a properly scoped *err* variable.

This project is part of [Nelson Cash](http://nelsoncash.com/)'s *work on your own stuff Friday* initiative.
We're supposed to create, have fun, and be experimental.

Prior Art
=========
[gofmt](https://golang.org/cmd/gofmt/)
[goreturns](https://github.com/sqs/goreturns)
[goimports](https://github.com/bradfitz/goimports)









