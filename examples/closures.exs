# Anonymous functions capture the variables in scope
# where they're defined, forming *closures*.

# `counter_from` returns a function that closes over
# `start`. Each call adds to the captured value.
counter_from = fn start ->
  fn step -> start + step end
end

from_ten = counter_from.(10)
IO.puts(from_ten.(1))
IO.puts(from_ten.(5))

# Because data is immutable, a closure can't change the
# variables it captured. Rebinding the outer variable
# later doesn't affect the closure either.
x = 1
get_x = fn -> x end
x = 100
IO.puts("x is #{x}, closure still sees #{get_x.()}")

# So how do you get a counter that remembers state between
# calls, like Go's closure-based `intSeq`? In Elixir,
# state lives in a *process*. Here we use an
# [Agent](agents.html) to hold the counter.
{:ok, counter} = Agent.start_link(fn -> 0 end)

next_int = fn ->
  Agent.get_and_update(counter, fn n -> {n + 1, n + 1} end)
end

IO.puts(next_int.())
IO.puts(next_int.())
IO.puts(next_int.())
