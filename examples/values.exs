# Elixir has various value types including strings,
# integers, floats, booleans, atoms, etc. Here are a few
# basic examples.

# Strings are UTF-8 binaries and can be joined with `<>`.
IO.puts("elixir" <> "lang")

# Integers and floats. Integers have arbitrary precision,
# so they never overflow.
IO.puts("1+1 = #{1 + 1}")
IO.puts("7.0/3.0 = #{7.0 / 3.0}")
IO.puts("2 ** 100 = #{2 ** 100}")

# `/` always returns a float; use `div` and `rem` for
# integer division.
IO.puts("7 / 2 = #{7 / 2}")
IO.puts("div(7, 2) = #{div(7, 2)}")
IO.puts("rem(7, 2) = #{rem(7, 2)}")

# Booleans, with the boolean operators you'd expect.
IO.puts(true and false)
IO.puts(true or false)
IO.puts(not true)

# `IO.inspect/1` prints any value in its Elixir syntax,
# which is handy when `IO.puts/1` can't display it.
IO.inspect(:an_atom)
IO.inspect(nil)
IO.inspect(1_000_000)
