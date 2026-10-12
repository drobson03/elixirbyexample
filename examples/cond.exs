# `cond` checks a series of conditions and runs the body
# of the first one that's truthy. It's Elixir's answer to
# `else if` chains.

classify = fn n ->
  cond do
    n < 0 -> "negative"
    n == 0 -> "zero"
    n < 10 -> "has 1 digit"
    true -> "has multiple digits"
  end
end

# The final `true ->` clause always matches, acting as an
# `else`. Without it, `cond` raises a `CondClauseError` if
# no condition is truthy.
for n <- [-5, 0, 9, 42] do
  IO.puts("#{n} #{classify.(n)}")
end

# Use `cond` when you're testing several unrelated
# conditions; use `case` when you're matching one value
# against patterns. Here's FizzBuzz with `cond`:
for n <- 1..15 do
  cond do
    rem(n, 15) == 0 -> "FizzBuzz"
    rem(n, 3) == 0 -> "Fizz"
    rem(n, 5) == 0 -> "Buzz"
    true -> n
  end
end
|> Enum.join(" ")
|> IO.puts()
