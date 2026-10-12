# Besides `raise`/`rescue`, Elixir has `throw`/`catch` for
# non-local returns, and `exit` for signalling that a
# process should stop. `after` runs cleanup code no
# matter what.

# `throw` and `catch` jump out of deeply nested code with
# a value. It's rarely needed, but it's useful with APIs
# that don't let you stop early.
result =
  try do
    Enum.each(1..100, fn x ->
      if rem(x, 13) == 0, do: throw({:found, x})
    end)

    :not_found
  catch
    {:found, x} -> "first multiple of 13 is #{x}"
  end

IO.puts(result)

# `catch` can also catch exits. The kind of error is
# given before the colon: `:throw`, `:exit` or `:error`.
caught =
  try do
    exit(:shutdown)
  catch
    :exit, reason -> "caught exit: #{inspect(reason)}"
  end

IO.puts(caught)

# `after` always runs, whether the body succeeds or
# raises. Use it to release resources. (Any `rescue` runs
# first.)
try do
  IO.puts("opening resource")
  raise "boom"
rescue
  e -> IO.puts("rescued #{e.message}")
after
  IO.puts("closing resource")
end

# `else` handles the result of the body when it didn't
# raise, letting you pattern match on success.
check = fn x ->
  try do
    1 / x
  rescue
    ArithmeticError -> :infinity
  else
    y when y > 0.5 -> {:big, y}
    y -> {:small, y}
  end
end

IO.inspect(check.(1))
IO.inspect(check.(4))
IO.inspect(check.(0))
