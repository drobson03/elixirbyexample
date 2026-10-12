# Elixir has exceptions, but they're used for truly
# exceptional situations. For expected failures, functions
# usually return `{:ok, value}` or `{:error, reason}`
# tuples instead (see [Ok and Error Tuples](ok-and-error-tuples.html)).

# `raise` raises a `RuntimeError` with a message.
try do
  raise "something went wrong"
rescue
  e in RuntimeError -> IO.puts("rescued: " <> e.message)
end

# You can raise a specific exception type with options.
try do
  raise ArgumentError, message: "bad argument"
rescue
  e in ArgumentError ->
    IO.puts("rescued #{inspect(e.__struct__)}: #{e.message}")
end

# Errors raised by the runtime are exceptions too. Use
# `Exception.message/1` to get a readable description.
try do
  1 / String.to_integer("0")
rescue
  e -> IO.puts("#{inspect(e.__struct__)}: #{Exception.message(e)}")
end

# Many functions come in two flavours: one that returns a
# tuple, and a `!` version that raises.
IO.inspect(File.read("missing.txt"))

try do
  File.read!("missing.txt")
rescue
  e in File.Error -> IO.puts(Exception.message(e))
end

# A function body can have `rescue` directly, without an
# explicit `try`.
defmodule Safe do
  def to_int(s) do
    String.to_integer(s)
  rescue
    ArgumentError -> :not_a_number
  end
end

IO.inspect(Safe.to_int("42"))
IO.inspect(Safe.to_int("forty-two"))

# In practice, Elixir developers rarely rescue. The
# "let it crash" philosophy says to let a failing
# process die and have a [supervisor](supervisors.html)
# restart it in a known-good state.
