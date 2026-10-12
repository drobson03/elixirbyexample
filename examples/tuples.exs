# Tuples are fixed-size containers, written with curly
# braces. They store their elements contiguously in
# memory, so accessing an element by index is fast.

t = {:ok, "hello", 42}
IO.inspect(t)

# Get the size and access elements by (zero-based) index.
IO.puts(tuple_size(t))
IO.puts(elem(t, 1))

# Like all Elixir data, tuples are immutable. `put_elem`
# returns a new tuple and leaves the original alone.
t2 = put_elem(t, 2, 99)
IO.inspect(t)
IO.inspect(t2)

# Tuples are most often used to return several values
# from a function, typically tagged with an atom like
# `:ok` or `:error`.
IO.inspect(File.read("does-not-exist.txt"))
IO.inspect(Integer.parse("12abc"))

# Pattern matching is the idiomatic way to pull values
# out of a tuple.
{status, message, _} = t
IO.puts("#{status}: #{message}")
