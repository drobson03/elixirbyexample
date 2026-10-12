# Named functions are grouped into modules, defined with
# `defmodule`. Functions are defined with `def`.

defmodule Math do
  # A public function. The last expression is the return
  # value; there's no `return` keyword.
  def plus(a, b) do
    a + b
  end

  # Short functions can use the one-line `do:` syntax.
  def plus_plus(a, b, c), do: plus(a, b) + c

  # `defp` defines a private function, only callable from
  # inside the module.
  def square_sum(a, b), do: square(a) + square(b)
  defp square(x), do: x * x

  # Functions ending in `?` return booleans by convention,
  # and functions ending in `!` raise on failure.
  def zero?(0), do: true
  def zero?(_), do: false
end

# Call module functions as `Module.function(args)`.
IO.puts(Math.plus(1, 2))
IO.puts(Math.plus_plus(1, 2, 3))
IO.puts(Math.square_sum(3, 4))
IO.puts(Math.zero?(0))

# Functions are identified by name *and* arity, so
# `plus/2` and `plus_plus/3` are completely separate
# functions. Calling a private function from outside
# raises an `UndefinedFunctionError`.
IO.puts(function_exported?(Math, :plus, 2))
IO.puts(function_exported?(Math, :square, 1))

# Modules can be nested, which simply creates a longer
# name like `Shapes.Circle`.
defmodule Shapes.Circle do
  def area(r), do: :math.pi() * r * r
end

IO.puts(Float.round(Shapes.Circle.area(2), 2))
