# Lists are Elixir's go-to sequential collection. They are
# singly linked lists, so prepending is fast and getting
# the length is linear.

list = [1, 2, 3]
IO.inspect(list)

# Lists can hold values of any type.
IO.inspect([1, :two, "three", 4.0])

# `++` concatenates and `--` subtracts lists.
IO.inspect(list ++ [4, 5])
IO.inspect([1, 2, 3, 2] -- [2])

# Prepend with `[new | list]`. This is O(1), whereas
# appending has to copy the whole list.
IO.inspect([0 | list])

# `hd` and `tl` return the head and tail.
IO.inspect(hd(list))
IO.inspect(tl(list))

# `length/1`, membership with `in`, and index access via
# `Enum.at/2`.
IO.puts(length(list))
IO.puts(2 in list)
IO.puts(Enum.at(list, 2))

# The `List` module has helpers for things specific to
# lists.
IO.inspect(List.first(list))
IO.inspect(List.last(list))
IO.inspect(List.flatten([1, [2, [3, 4]], 5]))
IO.inspect(List.insert_at(list, 1, :x))
