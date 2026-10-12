# Sometimes our programs need to run other programs.
# `System.cmd/3` runs an executable and returns its
# output and exit status.

# Run a simple command with arguments. It's not run
# through a shell, so arguments are passed exactly as
# given, with no risk of shell injection.
{output, status} = System.cmd("date", ["-u", "+%Y"])
IO.puts("> date")
IO.write(output)
IO.puts("exit status: #{status}")

# A non-zero exit status is returned, not raised.
# `stderr_to_stdout: true` captures error output too.
{output, status} = System.cmd("ls", ["/no/such/dir"], stderr_to_stdout: true)
IO.puts("ls failed with status #{status}")
IO.puts(String.contains?(output, "No such file"))

# `System.shell/2` runs a command line through the
# shell, so pipes and redirects work. Only use it with
# trusted strings!
{output, 0} = System.shell("printf 'hello grep\\ngoodbye grep\\n' | grep hello")
IO.puts("> grep hello")
IO.write(output)

# Set environment variables for the child with `env:`.
{output, 0} =
  System.cmd("sh", ["-c", "echo $GREETING"], env: [{"GREETING", "hi from env"}])

IO.write(output)

# `into: IO.stream()` streams output straight to our
# stdout as it's produced, instead of collecting it.
System.cmd("echo", ["streamed directly"], into: IO.stream())

# For long-running programs you want to talk to
# interactively, look at `Port.open/2`.
