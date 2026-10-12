# The `Enum` module is the workhorse for working with
# collections. Its functions accept any *enumerable*:
# lists, maps, ranges, MapSets, streams and more.

nums = [3, 1, 4, 1, 5, 9, 2, 6]

# Transform, filter and reduce.
IO.inspect(Enum.map(nums, &(&1 * 2)))
IO.inspect(Enum.filter(nums, &(&1 > 3)))
IO.inspect(Enum.reject(nums, &(&1 > 3)))
IO.inspect(Enum.reduce(nums, 0, fn n, acc -> n + acc end))

# Common aggregations.
IO.inspect({Enum.sum(nums), Enum.min(nums), Enum.max(nums), Enum.count(nums)})

# Search.
IO.inspect(Enum.find(nums, &(&1 > 4)))
IO.inspect(Enum.any?(nums, &(&1 > 8)))
IO.inspect(Enum.all?(nums, &(&1 > 0)))
IO.inspect(Enum.member?(nums, 7))

# Slicing and reshaping.
IO.inspect(Enum.take(nums, 3))
IO.inspect(Enum.drop(nums, 5))
IO.inspect(Enum.uniq(nums))
IO.inspect(Enum.chunk_every(nums, 3))
IO.inspect(Enum.zip([:a, :b, :c], [1, 2, 3]))
IO.inspect(Enum.with_index([:a, :b]))

# Grouping and counting.
words = ~w(apple avocado banana blueberry cherry)
IO.inspect(Enum.group_by(words, &String.first/1))
IO.inspect(Enum.frequencies(~w(a b a c b a)))

# Maps are enumerated as `{key, value}` tuples, and
# `Enum.into/2` or `Map.new/2` turn results back into a
# map.
prices = %{apple: 1.0, pear: 2.5}
IO.inspect(Map.new(prices, fn {k, v} -> {k, v * 2} end))

# `Enum.map_reduce/3` maps and accumulates in one pass.
IO.inspect(Enum.map_reduce([1, 2, 3], 0, fn x, acc -> {x * 2, acc + x} end))
