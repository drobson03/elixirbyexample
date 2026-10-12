# A *supervisor* starts child processes, watches them,
# and restarts them when they crash. Supervision trees
# are how Elixir applications stay up for years.

Logger.configure(level: :none)

# A tiny worker that keeps a counter and can be told to
# crash.
defmodule Worker do
  use GenServer

  def start_link(name), do: GenServer.start_link(__MODULE__, 0, name: name)

  @impl true
  def init(n) do
    IO.puts("#{inspect(self())} starting with #{n}")
    {:ok, n}
  end

  @impl true
  def handle_call(:incr, _from, n), do: {:reply, n + 1, n + 1}
  def handle_call(:crash, _from, _n), do: raise("crash!")
end

# Each child is described by a *child spec*. Passing
# `{Worker, :a}` means "call `Worker.start_link(:a)`".
children = [
  Supervisor.child_spec({Worker, :a}, id: :a),
  Supervisor.child_spec({Worker, :b}, id: :b)
]

# `:one_for_one` restarts only the child that crashed.
# Other strategies are `:one_for_all` and
# `:rest_for_one`.
{:ok, sup} = Supervisor.start_link(children, strategy: :one_for_one)

IO.puts(GenServer.call(:a, :incr))
IO.puts(GenServer.call(:a, :incr))
IO.puts(GenServer.call(:b, :incr))

# Crash worker `:a`. The call raises in our process too,
# so we catch the exit.
try do
  GenServer.call(:a, :crash)
catch
  :exit, _ -> IO.puts("worker :a crashed")
end

# The supervisor restarted `:a` with a fresh state (and a
# new PID), while `:b` kept its state.
Process.sleep(50)
IO.puts(GenServer.call(:a, :incr))
IO.puts(GenServer.call(:b, :incr))

IO.inspect(Supervisor.count_children(sup))

# For children started on demand (one per user, per
# connection, ...) use a `DynamicSupervisor` instead.
