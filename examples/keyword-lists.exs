# A keyword list is a list of 2-tuples whose first element
# is an atom. They're commonly used to pass options to
# functions.

opts = [size: 10, color: "red"]

# This is just syntax sugar for a list of tuples.
IO.inspect(opts == [{:size, 10}, {:color, "red"}])

# Access values with `[]` or the `Keyword` module.
IO.inspect(opts[:color])
IO.inspect(Keyword.get(opts, :missing, "default"))

# Unlike maps, keyword lists keep their order and allow
# duplicate keys. `Keyword.get/2` returns the first one.
dupes = [a: 1, b: 2, a: 3]
IO.inspect(Keyword.get(dupes, :a))
IO.inspect(Keyword.get_values(dupes, :a))

# When a keyword list is the last argument to a function,
# the square brackets are optional. This is how many
# Elixir APIs read so naturally.
IO.inspect(String.split("a,b,,c", ",", trim: true))

# In fact, `if`, `def` and friends use keyword lists for
# their `do:` and `else:` blocks.
IO.puts(if true, do: "yes", else: "no")

# Merge and update keyword lists.
IO.inspect(Keyword.merge(opts, size: 20))
IO.inspect(Keyword.put(opts, :weight, 3))
