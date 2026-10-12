# An `Agent` is a simple process that holds state. Other
# processes read and update that state through functions.

# Start an agent with its initial state: an empty map.
{:ok, store} = Agent.start_link(fn -> %{} end)

# `Agent.update/2` changes the state; `Agent.get/2` reads
# it. Both take a function that receives the current
# state.
Agent.update(store, &Map.put(&1, :lang, "Elixir"))
Agent.update(store, &Map.put(&1, :year, 2012))
IO.inspect(Agent.get(store, & &1))
IO.inspect(Agent.get(store, &Map.get(&1, :lang)))

# `get_and_update/2` does both atomically, returning a
# value and the new state.
old =
  Agent.get_and_update(store, fn state ->
    {state.year, %{state | year: 2026}}
  end)

IO.puts("year was #{old}, now #{Agent.get(store, & &1.year)}")

# Because all updates go through the agent's process one
# at a time, many concurrent writers can't trample each
# other. Here 1,000 tasks each increment a counter.
{:ok, counter} = Agent.start_link(fn -> 0 end)

1..1000
|> Enum.map(fn _ -> Task.async(fn -> Agent.update(counter, &(&1 + 1)) end) end)
|> Task.await_many()

IO.puts("counter: #{Agent.get(counter, & &1)}")

# Agents can be registered with a name, so you don't
# have to pass the PID around.
Agent.start_link(fn -> [] end, name: :log)
Agent.update(:log, &["started" | &1])
IO.inspect(Agent.get(:log, & &1))

Agent.stop(store)
