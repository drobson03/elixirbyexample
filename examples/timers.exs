# Timers let you run code in the future, once or
# repeatedly. In Elixir, a timer is just a message
# delivered to a process after a delay.

# `Process.send_after/3` sends a message after a delay in
# milliseconds and returns a timer reference.
start = System.monotonic_time(:millisecond)
Process.send_after(self(), :timer1, 200)

receive do
  :timer1 ->
    elapsed = System.monotonic_time(:millisecond) - start
    IO.puts("Timer 1 fired after ~#{elapsed}ms")
end

# Timers can be cancelled before they fire.
timer2 = Process.send_after(self(), :timer2, 100)
Process.cancel_timer(timer2)
IO.puts("Timer 2 stopped")

receive do
  :timer2 -> IO.puts("Timer 2 fired")
after
  200 -> IO.puts("Timer 2 never fired")
end

# For a *ticker* that fires repeatedly, schedule the next
# tick each time one arrives. Here a GenServer ticks every
# 100ms and stops after 3 ticks.
defmodule Ticker do
  use GenServer

  def start_link(parent), do: GenServer.start_link(__MODULE__, parent)

  @impl true
  def init(parent) do
    schedule()
    {:ok, {parent, 0}}
  end

  @impl true
  def handle_info(:tick, {parent, 2}) do
    IO.puts("Tick 3")
    send(parent, :done)
    {:stop, :normal, nil}
  end

  def handle_info(:tick, {parent, n}) do
    IO.puts("Tick #{n + 1}")
    schedule()
    {:noreply, {parent, n + 1}}
  end

  defp schedule, do: Process.send_after(self(), :tick, 100)
end

Ticker.start_link(self())

receive do
  :done -> IO.puts("Ticker stopped")
end
