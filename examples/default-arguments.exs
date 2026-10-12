# Named functions can give arguments a default value with
# `\\`.

defmodule Greeting do
  def hello(name, greeting \\ "Hello") do
    "#{greeting}, #{name}!"
  end
end

IO.puts(Greeting.hello("Ada"))
IO.puts(Greeting.hello("Ada", "Howdy"))

# Behind the scenes Elixir generates one function for each
# arity: here `hello/1` and `hello/2`.
IO.puts(function_exported?(Greeting, :hello, 1))

# When a function with defaults has multiple clauses, you
# declare the defaults once in a bodiless *function head*.
defmodule Join do
  def join(a, b \\ nil, sep \\ " ")

  def join(a, nil, _sep), do: a
  def join(a, b, sep), do: a <> sep <> b
end

IO.puts(Join.join("Hello"))
IO.puts(Join.join("Hello", "world"))
IO.puts(Join.join("Hello", "world", "_"))

# Keyword lists are the idiomatic way to accept many
# optional settings. `Keyword.get/3` takes a default.
defmodule Pad do
  def pad(text, opts \\ []) do
    width = Keyword.get(opts, :width, 10)
    char = Keyword.get(opts, :char, ".")
    String.pad_trailing(text, width, char) <> "|"
  end
end

IO.puts(Pad.pad("hi"))
IO.puts(Pad.pad("hi", width: 5, char: "-"))
