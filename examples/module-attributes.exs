# Module attributes, written `@name`, serve three
# purposes: annotations, constants and temporary storage
# during compilation.

defmodule Settings do
  # `@moduledoc` and `@doc` are annotations used for
  # documentation tools like ExDoc and `h` in IEx.
  @moduledoc "Settings for our app."

  # Attributes work as compile-time constants. Their value
  # is inlined wherever they're used.
  @max_retries 3
  @greeting "hello"

  @doc "Returns the retry limit."
  def max_retries, do: @max_retries

  # Attributes can be computed at compile time with any
  # expression.
  @squares for n <- 1..5, do: n * n
  def squares, do: @squares

  # Redefining an attribute affects code that comes after
  # it, which is handy for per-function metadata.
  @greeting "bonjour"
  def greeting, do: @greeting
end

IO.puts(Settings.max_retries())
IO.inspect(Settings.squares())
IO.puts(Settings.greeting())

# Other common built-in attributes include `@spec` and
# `@type` for typespecs, `@impl` for behaviours, and
# `@deprecated` to warn callers.
