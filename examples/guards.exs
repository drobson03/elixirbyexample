# Guards add extra conditions to pattern matches with the
# `when` keyword. They work in function clauses, `case`,
# anonymous functions and more.

defmodule Check do
  def kind(x) when is_integer(x) and x < 0, do: "negative integer"
  def kind(x) when is_integer(x), do: "integer"
  def kind(x) when is_float(x), do: "float"
  def kind(x) when is_binary(x) and byte_size(x) > 0, do: "string"
  def kind(x) when x in [nil, false], do: "falsy"
  def kind(_), do: "something else"
end

for value <- [-3, 7, 2.5, "hi", nil, ""] do
  IO.puts("#{inspect(value)} -> #{Check.kind(value)}")
end

# Only a limited set of expressions is allowed in guards:
# comparisons, boolean operators, arithmetic, type checks
# like `is_list/1`, and a few functions such as
# `length/1` and `map_size/1`. This keeps guards fast and
# free of side effects.
#
# You can define your own guards with `defguard`, built
# from those allowed expressions.
defmodule Num do
  defguard is_even(n) when is_integer(n) and rem(n, 2) == 0

  def parity(n) when is_even(n), do: :even
  def parity(n) when is_integer(n), do: :odd
end

IO.inspect(Enum.map(1..4, &Num.parity/1))

# If a guard raises an error, it simply counts as not
# matching instead of crashing.
f = fn
  x when map_size(x) > 0 -> "non-empty map"
  _ -> "not a non-empty map"
end

IO.puts(f.(%{a: 1}))
IO.puts(f.(:not_a_map))
