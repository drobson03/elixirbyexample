# `Task.async_stream/3` processes a collection
# concurrently with a bounded number of workers, a simple
# and robust way to build a worker pool.

# Our job simulates an expensive operation by sleeping
# for a second.
job = fn id ->
  IO.puts("worker #{inspect(self())} started job #{id}")
  Process.sleep(1000)
  id * 2
end

# Run 5 jobs with at most 3 at a time. Results come back
# in the original order by default, as `{:ok, result}`
# tuples.
{micros, results} =
  :timer.tc(fn ->
    1..5
    |> Task.async_stream(job, max_concurrency: 3)
    |> Enum.map(fn {:ok, result} -> result end)
  end)

IO.inspect(results)

# Despite doing about 5 seconds of total work, the
# program only takes about 2 seconds because 3 workers
# run in parallel.
IO.puts("took ~#{round(micros / 1_000_000)}s")

# `timeout:` limits each job's run time, and
# `on_timeout: :kill_task` turns a timed-out job into an
# `{:exit, :timeout}` result instead of crashing the
# caller.
[50, 500, 50]
|> Task.async_stream(&Process.sleep/1, timeout: 200, on_timeout: :kill_task)
|> Enum.to_list()
|> IO.inspect()
