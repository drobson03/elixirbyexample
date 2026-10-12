# Protocols are Elixir's mechanism for polymorphism: a
# protocol defines a set of functions, and each data type
# can provide its own implementation.

# Here's a protocol for computing the size of something.
defprotocol Size do
  @doc "Returns the size of the data structure"
  def size(data)
end

# Implement it for built-in types with `defimpl ... for:`.
defimpl Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end

IO.puts(Size.size("hello"))
IO.puts(Size.size(%{a: 1, b: 2}))
IO.puts(Size.size({1, 2, 3}))

# Calling a protocol on a type without an implementation
# raises `Protocol.UndefinedError`.
try do
  Size.size([1, 2])
rescue
  Protocol.UndefinedError -> IO.puts("no Size implementation for lists")
end

# Structs can implement protocols too. Implementing
# Elixir's own protocols, like `String.Chars` (used by
# string interpolation) or `Inspect`, integrates your
# types with the rest of the language.
defmodule Point do
  defstruct x: 0, y: 0
end

defimpl String.Chars, for: Point do
  def to_string(%Point{x: x, y: y}), do: "(#{x}, #{y})"
end

defimpl Size, for: Point do
  def size(_), do: 2
end

defmodule Main do
  def run do
    p = %Point{x: 3, y: 4}
    IO.puts("The point is #{p}")
    IO.puts(Size.size(p))
  end
end

Main.run()
