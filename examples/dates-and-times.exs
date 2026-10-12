# Elixir has four main calendar types: `Date`, `Time`,
# `NaiveDateTime` (a date and time with no time zone) and
# `DateTime` (a date and time in a specific time zone).

# Get the current time in UTC.
now = DateTime.utc_now()
IO.inspect(now)

# Build a specific date and time. Sigils are the easiest
# way to write literals.
then = ~U[2009-11-17 20:34:58.651387Z]
IO.inspect(then)

# Extract the components.
IO.inspect({then.year, then.month, then.day})
IO.inspect({then.hour, then.minute, then.second})
IO.inspect(then.microsecond)
IO.inspect(then.time_zone)
IO.inspect(Date.day_of_week(then))

# Compare with `DateTime.compare/2` (not `<`, which
# compares structurally and gives wrong answers for
# dates).
IO.inspect(DateTime.compare(then, now))
IO.inspect(DateTime.before?(then, now))

# Compute the difference between two times in any unit.
IO.inspect(DateTime.diff(~U[2026-10-12 12:00:00Z], then, :day))
IO.inspect(DateTime.diff(~U[2026-10-12 12:00:00Z], then, :hour))

# Add or subtract a duration.
IO.inspect(DateTime.add(then, 90, :minute))
IO.inspect(DateTime.shift(then, month: 1, day: -3))

# Dates on their own support ranges and calendar math.
d = ~D[2026-02-27]
IO.inspect(Date.add(d, 2))
IO.inspect(Date.leap_year?(d))
IO.inspect(Date.end_of_month(d))
IO.inspect(Date.range(d, Date.add(d, 3)) |> Enum.map(&Date.day_of_week/1))

# Elixir ships with UTC only. To work with other time
# zones, add a time zone database such as the `tz` or
# `tzdata` package.
