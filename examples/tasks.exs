# Tasks are processes designed to run a single action,
# usually to compute a value concurrently.

# `Task.async/1` starts the work, and `Task.await/2`
# waits for its result (with a default 5 second timeout).
task = Task.async(fn -> Enum.sum(1..1_000_000) end)
IO.puts("doing other work while the task runs...")
IO.puts("task result: #{Task.await(task)}")

# Run several tasks at once and wait for all of them.
# These three sleeps happen concurrently, so the total
# time is about 300ms rather than 600ms.
{micros, results} =
  :timer.tc(fn ->
    [300, 200, 100]
    |> Enum.map(fn ms -> Task.async(fn -> Process.sleep(ms) && ms end) end)
    |> Task.await_many()
  end)

IO.inspect(results)
IO.puts("took ~#{div(micros, 100_000) * 100}ms")

# `Task.start/1` runs a fire-and-forget side effect when
# you don't need the result.
Task.start(fn -> IO.puts("fire and forget") end)
Process.sleep(20)

# `Task.yield/2` waits for a limited time and returns
# `nil` if the task isn't done, letting you decide what to
# do next.
slow = Task.async(fn -> Process.sleep(1000) end)

case Task.yield(slow, 100) || Task.shutdown(slow) do
  {:ok, result} -> IO.inspect(result)
  nil -> IO.puts("gave up on slow task")
end
