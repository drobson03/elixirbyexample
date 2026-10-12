# In Elixir, `=` is the *match operator*. It asserts that
# the right side matches the shape on the left, binding
# any variables along the way.

x = 1

# This works because `x` is 1, so the match succeeds.
1 = x
IO.puts("1 = x matched")

# Destructure tuples...
{a, b, c} = {:hello, "world", 42}
IO.inspect({a, b, c})

# ...and lists, including splitting a list into its head
# and tail with `|`.
[head | tail] = [1, 2, 3]
IO.inspect(head)
IO.inspect(tail)

# Match on maps. A map pattern only needs to mention the
# keys it cares about.
%{name: name} = %{name: "Ada", born: 1815}
IO.puts(name)

# Match on the start of a string with `<>`.
"Hello, " <> who = "Hello, Joe"
IO.puts(who)

# Patterns can be nested arbitrarily.
{:ok, %{items: [first | _]}} = {:ok, %{items: [:apple, :pear]}}
IO.inspect(first)

# When a match fails, a `MatchError` is raised. Here we
# rescue it so the program keeps running. (`Enum.fetch/2`
# returns `:error` for an empty list.)
try do
  {:ok, _} = Enum.fetch([], 0)
rescue
  MatchError -> IO.puts("the match failed")
end
