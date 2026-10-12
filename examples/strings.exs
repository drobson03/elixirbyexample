# Strings in Elixir are UTF-8 encoded binaries, written in
# double quotes.

s = "hello, wörld"

# `String.length/1` counts graphemes (what a user would
# call characters), while `byte_size/1` counts bytes.
IO.puts(String.length(s))
IO.puts(byte_size(s))

# `#{}` interpolates any expression into a string.
name = "José"
IO.puts("Hi #{name}, 1 + 2 = #{1 + 2}")

# Concatenate with `<>`.
IO.puts("foo" <> "bar")

# Strings support the usual escapes like `\n` and `\t`.
IO.puts("tab\tseparated\nnew line")

# Multi-line strings use heredocs, delimited by `"""`.
# Indentation up to the closing `"""` is stripped.
poem = """
Roses are red,
violets are blue.
"""

IO.write(poem)

# Since a string is a binary, you can see its raw bytes
# with `IO.inspect` and `binaries: :as_binaries`.
IO.inspect("hé", binaries: :as_binaries)

# Single quotes create a *charlist*, a list of code points.
# You'll mostly see these when talking to Erlang
# libraries. Elixir prints them with the `~c` sigil.
IO.inspect(~c"hello")
IO.inspect(String.to_charlist("abc"))
