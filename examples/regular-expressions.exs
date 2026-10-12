# Elixir supports regular expressions through the
# `Regex` module and the `~r` sigil. They use PCRE syntax.

r = ~r/p([a-z]+)ch/

# `=~` tests whether a string matches.
IO.puts("peach" =~ r)

# `Regex.run/2` returns the first match and its capture
# groups.
IO.inspect(Regex.run(r, "peach punch"))

# Get positions instead of text with `return: :index`.
IO.inspect(Regex.run(r, "peach punch", return: :index))

# `Regex.scan/2` finds all matches.
IO.inspect(Regex.scan(r, "peach punch pinch"))

IO.inspect(
  Regex.scan(r, "peach punch pinch", capture: :first)
  |> List.flatten()
)

# Named captures come back as a map.
date = ~r/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/
IO.inspect(Regex.named_captures(date, "Released on 2026-10-12"))

# Replace matches, using `\1` for capture groups or a
# function to compute the replacement.
IO.puts(Regex.replace(r, "a peach", "<fruit>"))
IO.puts(Regex.replace(~r/(\w+)@(\w+)/, "ada@example", "\\2 at \\1"))

IO.puts(
  Regex.replace(
    ~r/\d+/,
    "3 apples and 12 pears",
    &"#{String.to_integer(&1) * 2}"
  )
)

# Split on a pattern.
IO.inspect(Regex.split(~r/\s*[,;]\s*/, "a, b;c ,d"))

# Modifiers go after the closing delimiter: `i` for
# case-insensitive, `u` for Unicode, `x` for extended
# (whitespace and comments ignored).
IO.puts("HELLO" =~ ~r/hello/i)

# Build a regex at runtime with `Regex.compile/1`,
# escaping any user input with `Regex.escape/1`.
{:ok, dynamic} = Regex.compile("^" <> Regex.escape("1+1") <> "=2$")
IO.puts(Regex.match?(dynamic, "1+1=2"))
