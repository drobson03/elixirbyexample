# `Enum` functions are *eager*: each step builds a whole
# new collection. The `Stream` module offers *lazy*
# versions that compose steps and only do work when the
# result is needed.

# This doesn't compute anything yet; it just builds a
# recipe.
stream =
  1..1_000_000
  |> Stream.map(&(&1 * 3))
  |> Stream.filter(&(rem(&1, 2) == 0))

IO.inspect(stream |> Enum.take(5))

# Laziness means streams can be infinite. `Stream.iterate`
# repeatedly applies a function to its last value.
powers_of_two = Stream.iterate(1, &(&1 * 2))
IO.inspect(Enum.take(powers_of_two, 10))

# `Stream.cycle` repeats a collection forever and
# `Stream.unfold` generates values from an accumulator.
IO.inspect(Stream.cycle([:red, :green]) |> Enum.take(5))

fib = Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)
IO.inspect(Enum.take(fib, 12))

# Observe the evaluation order: with streams, each
# element flows through the whole pipeline before the
# next one starts.
1..3
|> Stream.map(&IO.inspect(&1, label: "map"))
|> Stream.filter(&IO.inspect(rem(&1, 2) == 1, label: "odd? #{&1}"))
|> Enum.to_list()
|> IO.inspect(label: "result")

# Many resources are exposed as streams, such as
# `File.stream!/1` for reading files line by line, so you
# can process huge files with constant memory.
