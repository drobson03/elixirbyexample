# `GenServer` is the standard abstraction for a process
# that holds state and handles requests. It wraps the
# receive loop from [message passing](message-passing.html)
# with a well-tested protocol for calls, casts,
# timeouts and supervision.

defmodule Stack do
  use GenServer

  # The *client API* runs in the caller's process. It's a
  # set of plain functions that hide the message passing.
  def start_link(initial) do
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def push(item), do: GenServer.cast(__MODULE__, {:push, item})
  def pop, do: GenServer.call(__MODULE__, :pop)
  def size, do: GenServer.call(__MODULE__, :size)

  # The *server callbacks* run inside the GenServer
  # process. `init/1` sets up the initial state.
  @impl true
  def init(initial), do: {:ok, initial}

  # `handle_call/3` handles synchronous requests. The
  # caller blocks until we return `{:reply, reply,
  # new_state}`.
  @impl true
  def handle_call(:pop, _from, [head | tail]), do: {:reply, {:ok, head}, tail}
  def handle_call(:pop, _from, []), do: {:reply, :empty, []}
  def handle_call(:size, _from, state), do: {:reply, length(state), state}

  # `handle_cast/2` handles asynchronous requests. The
  # caller doesn't wait for a reply.
  @impl true
  def handle_cast({:push, item}, state), do: {:noreply, [item | state]}

  # `handle_info/2` receives any other message, such as
  # timer messages or monitors' `:DOWN` notifications.
  @impl true
  def handle_info(:report, state) do
    IO.puts("stack has #{length(state)} items")
    {:noreply, state}
  end
end

{:ok, pid} = Stack.start_link([:a])
Stack.push(:b)
Stack.push(:c)
IO.puts(Stack.size())
IO.inspect(Stack.pop())
IO.inspect(Stack.pop())

# Plain messages end up in `handle_info/2`.
send(pid, :report)

IO.inspect(Stack.pop())
IO.inspect(Stack.pop())

# You can inspect a running GenServer's state for
# debugging with `:sys.get_state/1`.
IO.inspect(:sys.get_state(Stack))
