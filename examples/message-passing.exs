# Processes communicate by sending messages. Each process
# has a mailbox; `send/2` puts a message in it and
# `receive` takes messages out.

# Send ourselves a message, then receive it.
send(self(), {:hello, "world"})

receive do
  {:hello, msg} -> IO.puts("received hello #{msg}")
end

# `receive` blocks until a message matching one of its
# patterns arrives. Messages that don't match stay in the
# mailbox for later.
send(self(), :first)
send(self(), {:important, 42})

receive do
  {:important, n} -> IO.puts("got important #{n} first")
end

receive do
  :first -> IO.puts("then got :first")
end

# A common pattern is a long-lived process that loops,
# handling one message per iteration and carrying its
# state in the recursive call.
defmodule Counter do
  def loop(count) do
    receive do
      {:incr, by} ->
        loop(count + by)

      {:get, caller} ->
        send(caller, {:count, count})
        loop(count)
    end
  end
end

counter = spawn(fn -> Counter.loop(0) end)
send(counter, {:incr, 5})
send(counter, {:incr, 2})

# To get a reply, include your own PID in the message so
# the other process knows where to send it.
send(counter, {:get, self()})

receive do
  {:count, n} -> IO.puts("counter is at #{n}")
end

# Messages between two processes always arrive in the
# order they were sent. This pattern of a looping process
# holding state is exactly what [GenServer](genserver.html)
# formalizes.
