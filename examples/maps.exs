# Maps are Elixir's key-value data structure.

# Create a map with `%{}`. Keys can be any value.
m = %{"k1" => 7, "k2" => 13}
IO.inspect(m)

# Access a value with `map[key]`, which returns `nil` for
# missing keys.
IO.inspect(m["k1"])
IO.inspect(m["k3"])

# `map_size` returns the number of key/value pairs.
IO.puts(map_size(m))

# Maps are immutable: `Map.put` and `Map.delete` return
# new maps.
m = Map.put(m, "k3", 21)
m = Map.delete(m, "k2")
IO.inspect(m)

# `Map.fetch` tells you whether a key is present, which
# distinguishes a missing key from a stored `nil`.
IO.inspect(Map.fetch(m, "k2"))
IO.inspect(Map.fetch(m, "k1"))

# When all keys are atoms there's a shorthand syntax, and
# you can access values with `map.key`.
point = %{x: 1, y: 2}
IO.puts(point.x)

# Update existing keys with the `%{map | key: value}`
# syntax. It raises if the key doesn't exist, which helps
# catch typos.
point = %{point | y: 5}
IO.inspect(point)

# Iterate over a map with `Enum` functions; each entry is
# a `{key, value}` tuple.
for {k, v} <- point, do: IO.puts("#{k} -> #{v}")

# Maps are compared by value.
IO.puts(%{a: 1, b: 2} == %{b: 2, a: 1})
