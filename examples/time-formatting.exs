# Calendar types can be formatted and parsed in several
# ways.

t = ~U[2026-10-12 15:04:05.123456Z]

# ISO 8601 is the default; `to_string` and `inspect`
# both use it.
IO.puts(DateTime.to_iso8601(t))
IO.puts(Date.to_iso8601(DateTime.to_date(t)))

# Parse ISO 8601 strings back into structs. Parsing a
# string with an offset returns it in UTC, along with the
# original offset in seconds.
IO.inspect(DateTime.from_iso8601("2026-10-12T22:08:41+02:00"))
IO.inspect(Date.from_iso8601("2026-10-12"))
IO.inspect(Time.from_iso8601("23:50:07"))

# `Calendar.strftime/3` formats with `%` directives.
IO.puts(Calendar.strftime(t, "%Y-%m-%d %H:%M:%S"))
IO.puts(Calendar.strftime(t, "%a %b %-d %I:%M %p"))
IO.puts(Calendar.strftime(t, "%A, %d %B %Y"))
IO.puts(Calendar.strftime(t, "%H:%M:%S.%f"))
IO.puts(Calendar.strftime(t, "%j day of the year, %c"))

# Parsing errors come back as tagged tuples.
IO.inspect(Date.from_iso8601("2026-13-01"))
IO.inspect(DateTime.from_iso8601("8:41PM"))
