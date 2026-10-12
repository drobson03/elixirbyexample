# Elixir mostly formats strings with interpolation, but
# there are tools for padding, number formatting and
# printf-style output.

point = %{x: 1, y: 2}

# `inspect/2` gives you the Elixir representation of any
# value, similar to `%v` in other languages.
IO.puts("struct1: #{inspect(point)}")
IO.puts("type check: #{is_map(point)}")

# Interpolation calls `to_string/1`, which works for
# strings, numbers, atoms and lists of characters.
IO.puts("int: #{123}, float: #{3.14}, atom: #{:ok}")

# `Integer.to_string/2` converts to other bases.
IO.puts("bin: #{Integer.to_string(14, 2)}")
IO.puts("hex: #{Integer.to_string(456, 16)}")
IO.puts("char: #{<<33>>}")

# `Float.round/2` and `:erlang.float_to_binary/2` control
# decimal places.
IO.puts("float1: #{Float.round(78.98765, 2)}")
IO.puts("float2: #{:erlang.float_to_binary(78.9, decimals: 3)}")
IO.puts("float3: #{:erlang.float_to_binary(123_400_000.0, [:short])}")

# Pad values to fixed widths to line up columns.
right = &String.pad_leading(&1, 6)
left = &String.pad_trailing(&1, 6)
IO.puts("|" <> right.("12") <> "|" <> right.("345") <> "|")
IO.puts("|" <> left.("foo") <> "|" <> left.("b") <> "|")

# Erlang's `:io.format/2` gives printf-style formatting.
# `~s` is a string, `~p` pretty-prints any term, `~8.3f`
# is a float with width 8 and 3 decimals, `~n` is a
# newline.
:io.format("~s is ~p years old~n", ["Ada", 36])
:io.format("|~8.3f|~-6s|~6w|~n", [3.14159, "left", 42])

# `:io_lib.format/2` returns the result instead of
# printing it (as a charlist).
s = :io_lib.format("~5.1.0f", [2.5]) |> to_string()
IO.puts("formatted: #{s}")

# `IO.inspect/2` options help when printing data.
IO.inspect(Enum.to_list(1..30), limit: 5)
IO.inspect(255, base: :hex)
IO.inspect(%{list: [1, 2, 3], nested: %{a: 1}}, pretty: true, width: 20)
