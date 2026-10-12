# `Enum.sort/1` sorts any enumerable using Elixir's term
# ordering. It returns a new sorted list.

IO.inspect(Enum.sort(["c", "a", "b"]))
IO.inspect(Enum.sort([7, 2, 4]))

# Pass `:desc` to sort in descending order.
IO.inspect(Enum.sort([7, 2, 4], :desc))

# All values can be compared, even across types. The
# order is: number < atom < reference < function < port <
# pid < tuple < map < list < bitstring.
IO.inspect(Enum.sort([[1], "str", :atom, 3.0, {1, 2}, %{}, 1]))

# Check whether a list is already sorted.
nums = [2, 4, 7]
IO.puts(nums == Enum.sort(nums))

# Strings sort by their bytes, so uppercase comes before
# lowercase. Normalise the case if you want dictionary
# order.
IO.inspect(Enum.sort(["banana", "Apple", "cherry"]))
IO.inspect(Enum.sort_by(["banana", "Apple", "cherry"], &String.downcase/1))

# Structs like dates need a module that knows how to
# compare them. Pass the module (or `{:desc, Module}`).
dates = [~D[2026-01-05], ~D[2025-12-31], ~D[2026-01-01]]
IO.inspect(Enum.sort(dates, Date))
IO.inspect(Enum.sort(dates, {:desc, Date}))
