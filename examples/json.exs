# Since Elixir 1.18, the standard library includes a
# `JSON` module for encoding and decoding JSON. (Older
# projects typically use the `Jason` package, which has
# the same API.)

# Encode basic values.
IO.puts(JSON.encode!(true))
IO.puts(JSON.encode!(1))
IO.puts(JSON.encode!(2.34))
IO.puts(JSON.encode!("elixir"))

# Lists become arrays and maps become objects. Atoms are
# encoded as strings.
IO.puts(JSON.encode!(["apple", "peach", "pear"]))
IO.puts(JSON.encode!(%{apple: 5, lettuce: 7}))

# Nested data works as you'd expect.
IO.puts(JSON.encode!(%{page: 1, fruits: ["apple", "peach"], meta: nil}))

# Structs must opt in to encoding. `@derive` generates an
# encoder, with `only:` choosing the fields to include.
defmodule Response do
  @derive {JSON.Encoder, only: [:page, :fruits]}
  defstruct [:page, :fruits, :secret]
end

IO.puts(
  JSON.encode!(struct(Response, page: 2, fruits: ["kiwi"], secret: "shh"))
)

# Decoding gives you maps with string keys.
json = ~s({"num": 6.13, "strs": ["a", "b"], "ok": true, "none": null})
{:ok, data} = JSON.decode(json)
IO.inspect(data)

# Access decoded values like any other map, or pattern
# match on the structure you expect.
%{"num" => num, "strs" => [first | _]} = data
IO.inspect({num, first})

# Invalid input returns an error tuple.
IO.inspect(JSON.decode(~s({"broken": )))
