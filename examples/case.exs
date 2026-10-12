# `case` matches a value against a series of patterns and
# runs the first clause that matches.

i = Enum.random([1, 2, 3])
IO.puts("i is #{i}")

case i do
  1 -> IO.puts("one")
  2 -> IO.puts("two")
  3 -> IO.puts("three")
end

# Clauses can destructure the value and use guards with
# `when`. The `_` clause matches anything, like a
# `default` branch.
describe = fn value ->
  case value do
    {:ok, result} -> "success: #{result}"
    {:error, reason} -> "failed: #{reason}"
    n when is_integer(n) and n > 100 -> "a big number"
    n when is_integer(n) -> "a small number"
    _ -> "something else"
  end
end

IO.puts(describe.({:ok, 42}))
IO.puts(describe.({:error, "timeout"}))
IO.puts(describe.(500))
IO.puts(describe.(5))
IO.puts(describe.("hello"))

# `case` is an expression, so it returns the value of the
# clause that ran. If nothing matches, it raises a
# `CaseClauseError`.
day = Date.day_of_week(~D[2026-10-12])

kind =
  case day do
    d when d in [6, 7] -> :weekend
    _ -> :weekday
  end

IO.inspect(kind)
