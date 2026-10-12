# Comprehensions, written with `for`, loop over
# enumerables and collect the results into a list.

IO.inspect(for x <- [1, 2, 3], do: x * x)

# Add filters after the generator. Only elements where
# the filter is truthy are kept.
IO.inspect(for x <- 1..10, rem(x, 2) == 0, do: x)

# Multiple generators give you a cartesian product, like
# nested loops.
IO.inspect(for x <- [1, 2], y <- [:a, :b], do: {x, y})

# Generators are pattern matches. Elements that don't
# match the pattern are silently skipped.
results = [{:ok, 1}, {:error, "bad"}, {:ok, 3}]
IO.inspect(for {:ok, value} <- results, do: value)

# `into:` collects into something other than a list, such
# as a map or a string.
IO.inspect(for {k, v} <- %{a: 1, b: 2}, into: %{}, do: {k, v * 10})
IO.inspect(for c <- ~c"hello", into: "", do: <<c - 32>>)

# `uniq: true` drops duplicate results.
IO.inspect(for x <- [1, 1, 2, 3, 3], uniq: true, do: x * 2)

# `reduce:` turns the comprehension into a fold. Each
# clause receives the accumulator.
count =
  for word <- ~w(a long list of words), reduce: 0 do
    acc -> acc + String.length(word)
  end

IO.puts(count)

# You can even pattern match on binaries. Here we split
# RGB pixels out of a binary, three bytes at a time.
pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>
IO.inspect(for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b})
