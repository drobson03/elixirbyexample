# `if` and `else` in Elixir are expressions: they return a
# value rather than just running code.

# Here's a basic example.
if rem(7, 2) == 0 do
  IO.puts("7 is even")
else
  IO.puts("7 is odd")
end

# You can have an `if` without an `else`; it returns `nil`
# when the condition is falsy.
if rem(8, 4) == 0 do
  IO.puts("8 is divisible by 4")
end

# Since `if` returns a value, you can bind its result.
num = 9

message =
  if num < 0 do
    "#{num} is negative"
  else
    "#{num} is non-negative"
  end

IO.puts(message)

# Only `false` and `nil` are falsy. Everything else,
# including `0`, `""` and `[]`, is truthy.
for value <- [0, "", [], nil, false] do
  IO.puts("#{inspect(value)} is #{if value, do: "truthy", else: "falsy"}")
end

# There's no `else if` in Elixir. When you need several
# branches, reach for [`cond`](cond.html) or
# [`case`](case.html).
