# `receive` waits forever by default. An `after` clause
# sets a timeout in milliseconds, so your program can
# give up waiting.

parent = self()

# This process takes 200ms to reply.
spawn(fn ->
  Process.sleep(200)
  send(parent, {:result, "slow result"})
end)

# We only wait 100ms, so the timeout fires first.
receive do
  {:result, r} -> IO.puts(r)
after
  100 -> IO.puts("timeout 1")
end

# If we're willing to wait longer, we get the reply.
receive do
  {:result, r} -> IO.puts(r)
after
  300 -> IO.puts("timeout 2")
end

# `after 0` checks the mailbox without waiting at all,
# which is handy for draining or polling.
receive do
  msg -> IO.inspect(msg)
after
  0 -> IO.puts("mailbox is empty")
end

# Higher-level APIs take timeouts too, like
# `Task.yield/2` and `GenServer.call/3`.
task = Task.async(fn -> Process.sleep(500) end)
IO.inspect(Task.yield(task, 50))
Task.shutdown(task)
