# A `MapSet` is an unordered collection of unique values.

# Build a set from any enumerable. Duplicates are dropped.
set = MapSet.new([1, 2, 3, 2, 1])
IO.inspect(set)

# Add and remove elements. Like everything in Elixir,
# these return a new set.
set = set |> MapSet.put(4) |> MapSet.delete(1)
IO.inspect(set)

# Check membership with `MapSet.member?/2` or `in`.
IO.puts(MapSet.member?(set, 3))
IO.puts(10 in set)
IO.puts(MapSet.size(set))

# The classic set operations.
a = MapSet.new([1, 2, 3, 4])
b = MapSet.new([3, 4, 5])
IO.inspect(MapSet.union(a, b))
IO.inspect(MapSet.intersection(a, b))
IO.inspect(MapSet.difference(a, b))
IO.puts(MapSet.subset?(MapSet.new([1, 2]), a))

# Sets are enumerable, so all `Enum` functions work on
# them.
IO.inspect(Enum.map(b, &(&1 * 10)))
