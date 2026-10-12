# Parsing numbers from strings is a common task.

# `String.to_integer/1` and `String.to_float/1` raise if
# the string isn't exactly a number.
IO.inspect(String.to_integer("123"))
IO.inspect(String.to_float("1.234"))

# `Integer.parse/2` and `Float.parse/1` are more lenient.
# They return the number and the rest of the string, or
# `:error`.
IO.inspect(Integer.parse("456abc"))
IO.inspect(Float.parse("1.5e3 meters"))
IO.inspect(Integer.parse("wat"))

# Parse other bases by passing the base.
IO.inspect(String.to_integer("ff", 16))
IO.inspect(Integer.parse("0777", 8))
IO.inspect(String.to_integer("1011", 2))

# Elixir also accepts these literals directly in code.
IO.inspect({0xFF, 0o777, 0b1011})

# A common pattern to accept only a complete integer is
# to match on an empty rest.
parse_int = fn s ->
  case Integer.parse(s) do
    {n, ""} -> {:ok, n}
    _ -> :error
  end
end

IO.inspect(parse_int.("42"))
IO.inspect(parse_int.("42px"))

# Converting a non-numeric string with the strict
# functions raises an `ArgumentError`.
try do
  String.to_integer("nope")
rescue
  ArgumentError -> IO.puts("not a number")
end
