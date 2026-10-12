# Ranges represent a sequence of integers between two
# bounds, inclusive. They're lazy: a range only stores its
# first value, last value and step.

r = 1..5
IO.inspect(r)

# Ranges are enumerable.
IO.inspect(Enum.to_list(r))
IO.puts(Enum.sum(r))

# Use `in` to test membership; this is constant time.
IO.puts(3 in r)
IO.puts(10 in r)

# A custom step uses `first..last//step`.
IO.inspect(Enum.to_list(0..10//3))
IO.inspect(Enum.to_list(10..1//-2))

# A huge range costs nothing until you enumerate it.
big = 1..1_000_000_000
IO.inspect(Enum.take(big, 3))

# `Range.size/1` returns how many elements a range has.
IO.puts(Range.size(1..10//2))

# Ranges are great for building loops with `for` or
# `Enum.each`.
for i <- 1..3, do: IO.puts("iteration #{i}")
