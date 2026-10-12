# Variables on the left side of `=` are always rebound.
# Use the pin operator `^` when you want to match against
# a variable's *existing* value instead.

x = 1
IO.puts(x)

# Without the pin, `x` is simply rebound to 2.
x = 2
IO.puts(x)

# With the pin, the match compares against x's current
# value. This succeeds because x is 2...
^x = 2
IO.puts("^x = 2 matched")

# ...and this fails.
try do
  ^x = String.to_integer("3")
rescue
  MatchError -> IO.puts("^x = 3 does not match")
end

# Pins are especially useful inside larger patterns, for
# example to find a specific key in a list of tuples.
wanted = :b
pairs = [{:a, 1}, {:b, 2}, {:c, 3}]
IO.inspect(Enum.find(pairs, fn {k, _} -> k == wanted end))

for {^wanted, value} <- pairs do
  IO.puts("found #{wanted} = #{value}")
end
