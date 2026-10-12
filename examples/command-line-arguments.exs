# @args: a b c d --verbose --name=elixir
# Command-line arguments are a common way to parameterize
# execution of programs.

# `System.argv/0` gives the arguments as a list of
# strings, without the program name.
args = System.argv()
IO.inspect(args)

# Access individual arguments with normal list functions.
IO.inspect(Enum.at(args, 2))

# `OptionParser` turns flags into a keyword list. Pass
# `strict:` to declare each switch and its type. It
# returns the parsed options, the remaining positional
# arguments, and any invalid ones.
{opts, rest, invalid} =
  OptionParser.parse(args, strict: [verbose: :boolean, name: :string])

IO.inspect(opts)
IO.inspect(rest)
IO.inspect(invalid)

# For a real command-line app, you'd use `mix escript.build`
# to package your project into a single executable.
