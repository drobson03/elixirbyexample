# Elixir has no `for` or `while` loops that mutate a
# counter. Instead, repetition is expressed with recursion
# (and the higher-level `Enum` functions built on it).

defmodule Recur do
  # A classic recursive factorial. The first clause is the
  # base case that stops the recursion.
  def fact(0), do: 1
  def fact(n) when n > 0, do: n * fact(n - 1)

  # Recursing over a list: handle the empty list, then
  # the head, then recurse on the tail.
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)

  # A *tail-recursive* version carries an accumulator.
  # Because the recursive call is the last thing the
  # function does, the VM reuses the stack frame, so this
  # runs in constant stack space for any size of input.
  def sum_tail(list, acc \\ 0)
  def sum_tail([], acc), do: acc
  def sum_tail([head | tail], acc), do: sum_tail(tail, acc + head)

  def fib(n) when n < 2, do: n
  def fib(n), do: fib(n - 1) + fib(n - 2)
end

IO.puts(Recur.fact(7))
IO.puts(Recur.sum([1, 2, 3, 4]))
IO.puts(Recur.sum_tail(Enum.to_list(1..1_000_000)))

# Anonymous functions can't refer to themselves by name,
# but you can pass the function in as an argument.
fib = fn
  n, _self when n < 2 -> n
  n, self -> self.(n - 1, self) + self.(n - 2, self)
end

IO.puts(fib.(10, fib))
IO.puts(Recur.fib(20))
