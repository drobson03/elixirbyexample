# A *link* ties two processes together: if one exits
# abnormally, the other is sent an exit signal too and,
# by default, dies as well. Links are the foundation of
# Elixir's fault tolerance.

# Silence crash reports to keep the output readable.
Logger.configure(level: :none)

# `spawn_link/1` spawns and links in one step. To observe
# the crash without dying ourselves, we *trap exits*:
# exit signals from linked processes are converted into
# ordinary `{:EXIT, pid, reason}` messages.
Process.flag(:trap_exit, true)

pid = spawn_link(fn -> raise "boom" end)

receive do
  {:EXIT, ^pid, {%RuntimeError{message: msg}, _stack}} ->
    IO.puts("linked process crashed: #{msg}")
end

# A process that finishes normally exits with reason
# `:normal`, which doesn't kill linked processes.
pid = spawn_link(fn -> :ok end)

receive do
  {:EXIT, ^pid, reason} -> IO.puts("exited with #{inspect(reason)}")
end

# Without trapping, a linked crash takes the linked
# process down too. Here a middle process links to a
# crashing child and dies along with it.
Process.flag(:trap_exit, false)

middle =
  spawn(fn ->
    spawn_link(fn -> exit(:kaboom) end)
    Process.sleep(:infinity)
  end)

Process.sleep(50)
IO.puts("middle process alive? #{Process.alive?(middle)}")

# Supervisors use links and trapped exits to notice
# when their children die and restart them.
