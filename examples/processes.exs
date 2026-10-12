# Elixir code runs inside lightweight *processes*. They're
# not OS processes or threads: they're managed by the
# Erlang VM, cost just a few kilobytes each, and you can
# run millions of them at once.

# `self()` returns the current process's identifier (PID).
IO.inspect(self())

# `spawn/1` starts a function in a new process, which
# runs concurrently with the caller.
pid = spawn(fn -> IO.puts("hello from #{inspect(self())}") end)
IO.inspect(pid)

# Give it a moment to run, then check whether it's still
# alive. A process exits when its function returns.
Process.sleep(50)
IO.puts(Process.alive?(pid))

# Processes are isolated: they share no memory, and a
# crash in one doesn't affect the others. This crashing
# process doesn't take us down with it (we silence its
# error report here to keep the output tidy).
Logger.configure(level: :none)
spawn(fn -> raise "oops" end)
Process.sleep(50)
IO.puts("still running")

# Let's spawn 10,000 processes. Each sends its square
# back to us, and we collect them. Messages are covered
# in more detail in the [next example](message-passing.html).
parent = self()

for n <- 1..10_000 do
  spawn(fn -> send(parent, {:square, n * n}) end)
end

total =
  Enum.reduce(1..10_000, 0, fn _, acc ->
    receive do
      {:square, sq} -> acc + sq
    end
  end)

IO.puts("sum of squares: #{total}")
