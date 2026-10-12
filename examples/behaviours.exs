# A *behaviour* defines a set of functions that a module
# must implement. It's similar to an interface: a contract
# that lets you swap one implementation for another.

# Declare the required functions with `@callback`, using
# typespecs to describe arguments and return values.
defmodule Parser do
  @callback parse(String.t()) :: {:ok, term} | {:error, String.t()}
  @callback extensions() :: [String.t()]

  # Code written against the behaviour can work with any
  # module that implements it.
  def parse_with(module, text), do: module.parse(text)
end

# Modules opt in with `@behaviour`. `@impl true` marks the
# callback implementations, and the compiler warns if a
# callback is missing or misspelled.
defmodule CSVParser do
  @behaviour Parser

  @impl true
  def parse(text), do: {:ok, String.split(text, ",")}

  @impl true
  def extensions, do: [".csv"]
end

defmodule KVParser do
  @behaviour Parser

  @impl true
  def parse(text) do
    case String.split(text, "=") do
      [k, v] -> {:ok, %{k => v}}
      _ -> {:error, "expected key=value"}
    end
  end

  @impl true
  def extensions, do: [".env", ".ini"]
end

for parser <- [CSVParser, KVParser], input <- ["a,b,c", "name=elixir"] do
  IO.puts(
    "#{inspect(parser)} #{input} -> #{inspect(Parser.parse_with(parser, input))}"
  )
end

# Behaviours are everywhere in Elixir and OTP:
# [GenServer](genserver.html), `Supervisor` and
# `Application` are all behaviours.
IO.inspect(KVParser.extensions())
