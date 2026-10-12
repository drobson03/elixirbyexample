# A function can be defined with several clauses. Elixir
# tries them in order and runs the first one whose
# arguments match. This often replaces `if` and `case`.

defmodule Greeter do
  def hello(:es), do: "¡Hola!"
  def hello(:fr), do: "Bonjour !"
  def hello(_), do: "Hello!"
end

IO.puts(Greeter.hello(:es))
IO.puts(Greeter.hello(:fr))
IO.puts(Greeter.hello(:de))

# Clauses can destructure their arguments, which makes
# handling different shapes of data very clean.
defmodule Shape do
  def area({:square, side}), do: side * side
  def area({:rect, w, h}), do: w * h
  def area({:circle, r}), do: Float.round(:math.pi() * r * r, 2)
end

shapes = [{:square, 3}, {:rect, 2, 5}, {:circle, 1}]

for shape <- shapes do
  IO.puts("#{inspect(shape)} has area #{Shape.area(shape)}")
end

# If no clause matches, a `FunctionClauseError` is raised.
try do
  Shape.area({:triangle, 1, 2, 3})
rescue
  FunctionClauseError -> IO.puts("no clause for triangles")
end
