# Sigils are alternative syntaxes for literals, starting
# with `~` followed by a letter. Lowercase sigils allow
# escapes and interpolation; uppercase ones don't.

# `~s` creates a string; handy when the string contains
# double quotes.
IO.puts(~s(she said "hello"))

# `~w` creates a list of words. A trailing `a` or `c`
# modifier returns atoms or charlists.
IO.inspect(~w(foo bar baz))
IO.inspect(~w(foo bar baz)a)

# `~r` creates a regular expression.
IO.puts("hello world" =~ ~r/wor/)

# `~c` is a charlist, and `~S` is a raw string with no
# interpolation or escapes.
IO.inspect(~c"abc")
IO.puts(~S(no #{interpolation} or \n escapes))

# Date and time sigils parse literals at compile time.
IO.inspect(~D[2026-10-12])
IO.inspect(~T[13:45:00])
IO.inspect(~U[2026-10-12 13:45:00Z])

# Sigils accept many delimiters: `//`, `||`, `""`, `''`,
# `()`, `[]`, `{}` and `<>`, plus `"""` heredocs.
IO.inspect(~w|one two|)
IO.inspect(~w<three four>)

# You can define your own sigil by writing a
# `sigil_x/2` function. Here's one that parses a
# comma-separated list of integers.
defmodule MySigils do
  def sigil_i(string, []),
    do: string |> String.split(",") |> Enum.map(&String.to_integer/1)
end

# Import the module to use the sigil. (A script can't
# import a module at the top level in the same file that
# defines it, so we use it from inside another module.)
defmodule UsesSigils do
  import MySigils
  def numbers, do: ~i(1,2,3)
end

IO.inspect(UsesSigils.numbers())
