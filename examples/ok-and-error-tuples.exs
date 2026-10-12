# The idiomatic way to report expected errors in Elixir is
# to return a tagged tuple: `{:ok, result}` on success and
# `{:error, reason}` on failure. Callers then pattern
# match on the result.

defmodule Inventory do
  @stock %{"apple" => 5, "pear" => 0}

  def take(item, qty) do
    case Map.fetch(@stock, item) do
      :error -> {:error, :unknown_item}
      {:ok, have} when have < qty -> {:error, {:insufficient, have}}
      {:ok, have} -> {:ok, have - qty}
    end
  end
end

# Match on each possible outcome with `case`.
for {item, qty} <- [{"apple", 2}, {"pear", 1}, {"kiwi", 1}] do
  case Inventory.take(item, qty) do
    {:ok, left} -> IO.puts("took #{qty} #{item}, #{left} left")
    {:error, {:insufficient, have}} -> IO.puts("only #{have} #{item} available")
    {:error, reason} -> IO.puts("error: #{reason}")
  end
end

# The standard library follows this convention
# everywhere.
IO.inspect(Map.fetch(%{a: 1}, :a))
IO.inspect(Date.new(2026, 2, 30))
IO.inspect(File.stat("nope"))

# When failure would be a bug, assert success with a
# match. If it fails, a `MatchError` crashes the process
# with a clear message.
{:ok, date} = Date.new(2026, 10, 12)
IO.inspect(date)

# For chains of operations that can each fail, use
# [`with`](with.html).
