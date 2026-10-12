# In Elixir, variables are names bound to values. Values
# are immutable, but a name can be *rebound* to a new
# value.

# `=` binds the value on the right to the name on the left.
a = "initial"
IO.puts(a)

# You can bind several variables at once by matching on a
# tuple (more on this in [pattern matching](pattern-matching.html)).
{b, c} = {1, 2}
IO.puts("#{b} #{c}")

# Elixir is dynamically typed, so you never declare a
# variable's type.
d = true
IO.puts(d)

# Rebinding doesn't mutate the old value; it just points
# the name at something new. Any closures or data that
# captured the old value still see the old value.
e = 1
f = fn -> e end
e = 2
IO.puts("e is #{e}, but f.() is #{f.()}")

# Variables starting with an underscore are ignored by
# the compiler's unused-variable check. A bare `_`
# matches anything and discards it.
{_first, _} = {:ignored, :also_ignored}
IO.puts("done")
