# A common requirement is to get the number of seconds,
# milliseconds or nanoseconds since the Unix epoch.

# `System.os_time/1` returns the current Unix time in the
# given unit.
IO.puts(System.os_time(:second))
IO.puts(System.os_time(:millisecond))
IO.puts(System.os_time(:nanosecond))

# `DateTime.to_unix/2` converts a `DateTime`...
now = DateTime.utc_now()
IO.puts(DateTime.to_unix(now))

# ...and `DateTime.from_unix/2` converts back.
IO.inspect(DateTime.from_unix(1_234_567_890))
IO.inspect(DateTime.from_unix!(1_760_000_000_000, :millisecond))

# To measure elapsed time, use `System.monotonic_time/1`
# instead. Unlike the wall clock, it never jumps
# backwards when the system clock is adjusted.
start = System.monotonic_time(:millisecond)
Process.sleep(100)
elapsed = System.monotonic_time(:millisecond) - start
IO.puts("elapsed >= 100ms? #{elapsed >= 100}")
