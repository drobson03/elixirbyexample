# A *monitor* lets one process watch another without
# being linked to it. When the watched process exits for
# any reason, the watcher receives a `:DOWN` message. It's
# one-way, and the watcher never dies because of it.

Logger.configure(level: :none)

pid = spawn(fn -> Process.sleep(100) end)
ref = Process.monitor(pid)

receive do
  {:DOWN, ^ref, :process, ^pid, reason} ->
    IO.puts("process exited: #{inspect(reason)}")
end

# Monitors report crashes as well as normal exits.
{pid, ref} = spawn_monitor(fn -> exit(:something_bad) end)

receive do
  {:DOWN, ^ref, :process, ^pid, reason} ->
    IO.puts("process exited: #{inspect(reason)}")
end

# Monitoring a process that's already dead immediately
# delivers a `:DOWN` message with reason `:noproc`.
ref = Process.monitor(pid)

receive do
  {:DOWN, ^ref, :process, _, reason} ->
    IO.puts("already gone: #{inspect(reason)}")
end

# Use `Process.demonitor/2` to stop watching. The `:flush`
# option also removes any `:DOWN` message already in the
# mailbox.
pid = spawn(fn -> Process.sleep(1000) end)
ref = Process.monitor(pid)
IO.puts(Process.demonitor(ref, [:flush]))

# Monitors are ideal when you depend on a process but
# shouldn't crash with it, like a client waiting on a
# server. `Task.await/2` uses them under the hood.
