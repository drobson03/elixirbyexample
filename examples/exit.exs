# @exit: 3
# Use `System.halt/1` to immediately exit with a given
# status.

# Code in `after` blocks and other cleanup will *not*
# run when using `System.halt/1`, so this will never be
# printed.
try do
  IO.puts("about to exit")
  System.halt(3)
after
  IO.puts("this never prints")
end

# $ Elixir scripts exit with status 0 when they finish
# $ normally, and 1 when they crash with an uncaught
# $ exception. Use `System.halt/1` to choose a specific
# $ status.
# $
# $ `System.stop/1` is the gentler alternative: it shuts
# $ down applications and supervisors in order before
# $ exiting.
