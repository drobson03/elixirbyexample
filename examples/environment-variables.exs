# @env: BAR=2
# Environment variables are a universal mechanism for
# conveying configuration to programs.

# `System.put_env/2` sets a variable for this process
# (and any OS processes it starts). `System.get_env/1`
# reads one, returning `nil` if it's not set.
System.put_env("FOO", "1")
IO.inspect(System.get_env("FOO"))
IO.inspect(System.get_env("BAR"))

# Provide a default for missing variables.
IO.inspect(System.get_env("PORT", "4000"))

# `System.fetch_env/1` distinguishes "unset" from an
# empty string, and `fetch_env!/1` raises when the
# variable is required.
IO.inspect(System.fetch_env("MISSING"))

# `System.get_env/0` returns all variables as a map.
# Let's list a few names.
System.get_env()
|> Map.keys()
|> Enum.filter(&(&1 in ["FOO", "BAR", "HOME"]))
|> Enum.sort()
|> IO.inspect()

# $ Running the program shows that we pick up the value
# $ for `FOO` that we set in the program, and the value of
# $ `BAR` from the shell.
