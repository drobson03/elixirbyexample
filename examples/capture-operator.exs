# The capture operator `&` creates anonymous functions
# concisely.

# `&Module.function/arity` captures a named function so
# you can pass it around.
upcase = &String.upcase/1
IO.puts(upcase.("hello"))
IO.inspect(Enum.map(["a", "b"], &String.upcase/1))

# `&(...)` with placeholders `&1`, `&2`, ... is shorthand
# for a small anonymous function.
add = &(&1 + &2)
IO.puts(add.(2, 3))

# These two are equivalent:
IO.inspect(Enum.map([1, 2, 3], fn x -> x * 2 end))
IO.inspect(Enum.map([1, 2, 3], &(&1 * 2)))

# The capture syntax can also build tuples, lists and
# strings.
IO.inspect(Enum.map([1, 2], &{&1, &1 * &1}))
IO.inspect(Enum.map(["Ada", "Joe"], &"Hi #{&1}"))

# Local and imported functions can be captured too.
defmodule Util do
  def double(x), do: x * 2
  def run, do: Enum.map([1, 2, 3], &double/1)
end

IO.inspect(Util.run())

# Keep captures short; when a function needs a name or
# more than a line, prefer `fn`.
