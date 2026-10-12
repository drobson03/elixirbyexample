# Sometimes we want to sort a collection by something
# other than its natural order. `Enum.sort_by/3` and
# `Enum.sort/2` take functions to customise the order.

fruits = ["peach", "banana", "kiwi"]

# `sort_by` sorts by the value a function returns for
# each element. Here, by string length.
IO.inspect(Enum.sort_by(fruits, &String.length/1))

# Add `:desc` for reverse order.
IO.inspect(Enum.sort_by(fruits, &String.length/1, :desc))

# Sort by multiple keys by returning a tuple: tuples are
# compared element by element.
people = [
  %{name: "Alex", age: 30},
  %{name: "Jo", age: 25},
  %{name: "Sam", age: 30},
  %{name: "Ann", age: 25}
]

people
|> Enum.sort_by(&{-&1.age, &1.name})
|> Enum.map(&"#{&1.name} (#{&1.age})")
|> IO.inspect()

# `Enum.sort/2` takes a comparison function that returns
# `true` if the first argument should come first.
IO.inspect(Enum.sort(fruits, fn a, b -> String.last(a) <= String.last(b) end))

# `min_by` and `max_by` find extremes without sorting
# the whole list.
IO.inspect(Enum.max_by(people, & &1.age).name)
IO.inspect(Enum.min_by(fruits, &String.length/1))
