# An atom is a constant whose value is its own name. Atoms
# are used everywhere in Elixir to tag values and
# represent states.

# Atoms start with a colon.
status = :ok
IO.inspect(status)

# Atoms with the same name are always equal, and comparing
# them is very fast.
IO.puts(status == :ok)

# `true`, `false` and `nil` are atoms too; they're just
# written without the colon.
IO.puts(is_atom(true))
IO.puts(is_atom(nil))
IO.puts(String.to_atom("true") == true)

# Atoms can contain spaces or special characters if you
# quote them.
IO.inspect(:"hello world")

# Module names are also atoms, prefixed with `Elixir.`
# behind the scenes.
IO.puts(is_atom(String))
IO.inspect(String == :"Elixir.String")

# Convert between atoms and strings. Prefer
# `String.to_existing_atom/1` for untrusted input: atoms
# are never garbage collected, so creating them from user
# data can exhaust memory.
IO.inspect(Atom.to_string(:hello))
IO.inspect(String.to_existing_atom("hello"))
