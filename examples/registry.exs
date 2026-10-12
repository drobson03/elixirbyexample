# The `Registry` module maps names to processes, which
# lets you look up processes by any term, not just by
# atom names. Entries are removed automatically when a
# process dies.

# Start a registry with unique keys.
{:ok, _} = Registry.start_link(keys: :unique, name: Rooms)

defmodule Room do
  use GenServer

  # `{:via, Registry, {registry, key}}` names a process
  # through the registry, so any term can be its name.
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via(name))
  end

  def post(name, msg), do: GenServer.cast(via(name), {:post, msg})
  def history(name), do: GenServer.call(via(name), :history)

  defp via(name), do: {:via, Registry, {Rooms, name}}

  @impl true
  def init(name), do: {:ok, %{name: name, messages: []}}

  @impl true
  def handle_cast({:post, msg}, state),
    do: {:noreply, update_in(state.messages, &[msg | &1])}

  @impl true
  def handle_call(:history, _from, state),
    do: {:reply, Enum.reverse(state.messages), state}
end

{:ok, _} = Room.start_link({:room, "lobby"})
{:ok, _} = Room.start_link({:room, "elixir"})

Room.post({:room, "lobby"}, "hi all")
Room.post({:room, "elixir"}, "pipes are great")
Room.post({:room, "elixir"}, "so are processes")

IO.inspect(Room.history({:room, "elixir"}))

# Look up the PID behind a key, and list all keys.
[{pid, _value}] = Registry.lookup(Rooms, {:room, "lobby"})
IO.puts(is_pid(pid))

IO.inspect(
  Registry.select(Rooms, [{{:"$1", :_, :_}, [], [:"$1"]}])
  |> Enum.sort()
)

# When a process stops, its entry disappears.
GenServer.stop(pid)
Process.sleep(10)
IO.inspect(Registry.lookup(Rooms, {:room, "lobby"}))

# A registry with `keys: :duplicate` lets many processes
# register under the same key, which makes a simple
# pub/sub system.
