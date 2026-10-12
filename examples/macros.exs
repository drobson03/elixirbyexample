# Elixir code is itself data. Macros receive code as
# data, transform it, and return new code to compile.
# This is how much of Elixir, like `if` and `defstruct`,
# is built.

# `quote` shows the internal representation of code: an
# AST made of three-element tuples.
IO.inspect(quote do: 1 + 2 * 3)

# `unquote` injects a value into quoted code, much like
# interpolation in a string.
n = 10
ast = quote do: unquote(n) * 2
IO.inspect(ast)
IO.puts(Macro.to_string(ast))
IO.inspect(Code.eval_quoted(ast))

# A macro is defined with `defmacro`. It receives its
# arguments as ASTs and returns an AST. Here's an
# `unless`-style macro.
defmodule MyMacros do
  defmacro my_unless(condition, do: block) do
    quote do
      if unquote(condition), do: nil, else: unquote(block)
    end
  end

  # Macros can also generate functions at compile time.
  defmacro defgreeting(lang, text) do
    quote do
      def unquote(:"hello_#{lang}")(), do: unquote(text)
    end
  end

  # A macro can access its arguments' source code, which
  # lets this `check` show the expression that failed.
  defmacro check(expr) do
    source = Macro.to_string(expr)

    quote do
      if unquote(expr),
        do: "ok: #{unquote(source)}",
        else: "FAILED: #{unquote(source)}"
    end
  end
end

# Macros must be required (or imported) before use, and
# like structs they must be compiled before the code
# that uses them.
defmodule Main do
  import MyMacros

  defgreeting(:en, "Hello")
  defgreeting(:fr, "Bonjour")

  def run do
    my_unless 1 > 2 do
      IO.puts("math still works")
    end

    IO.puts(hello_en() <> " / " <> hello_fr())
    IO.puts(check(String.length("abc") == 3))
    IO.puts(check(Enum.sum([1, 2]) == 4))
  end
end

Main.run()

# Use macros sparingly: a plain function is almost always
# clearer when it can do the job.
