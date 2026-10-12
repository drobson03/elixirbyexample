# Anonymous functions are values: you can bind them to
# variables, pass them to other functions and return them.

# Define one with `fn ... end`. Call it with a dot.
add = fn a, b -> a + b end
IO.puts(add.(1, 2))

# The dot distinguishes calling an anonymous function
# stored in `add` from calling a named function `add`.
# Functions are first-class values with an *arity* (the
# number of arguments).
IO.puts(is_function(add, 2))

# Anonymous functions can have multiple clauses, each
# with its own pattern and guards.
handle = fn
  {:ok, value} -> "got #{value}"
  {:error, _} -> "oops"
end

IO.puts(handle.({:ok, 5}))
IO.puts(handle.({:error, :nope}))

# They're most often passed to higher-order functions.
IO.inspect(Enum.map([1, 2, 3], fn x -> x * x end))

# Functions can also return functions.
multiplier = fn factor -> fn x -> x * factor end end
triple = multiplier.(3)
IO.puts(triple.(7))
