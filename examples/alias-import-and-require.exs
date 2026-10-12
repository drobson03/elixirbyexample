# Elixir has three directives for working with other
# modules: `alias`, `import` and `require`. They're all
# *lexically scoped*, applying only to the block they
# appear in.

defmodule MyApp.Accounts.User do
  def new(name), do: %{name: name}
end

defmodule Example do
  # `alias` lets you refer to a module by a shorter name.
  # By default the alias is the last part of the name.
  alias MyApp.Accounts.User

  # `as:` picks a different name.
  alias MyApp.Accounts.User, as: Account

  def users, do: [User.new("Ada"), Account.new("Joe")]

  # `import` brings a module's functions into scope so you
  # can call them without the module prefix. Use `only:`
  # to keep it explicit.
  import String, only: [upcase: 1, duplicate: 2]

  def shout(text), do: upcase(text) <> duplicate("!", 3)

  # `require` is needed to use a module's *macros*.
  # `Integer.is_odd/1` is a macro, usable in guards.
  require Integer

  def odd_only(n) when Integer.is_odd(n), do: n
  def odd_only(_), do: :even
end

IO.inspect(Example.users())
IO.puts(Example.shout("hello"))
IO.inspect({Example.odd_only(3), Example.odd_only(4)})

# `use` is a fourth, more powerful directive: `use Foo`
# calls the `Foo.__using__/1` macro, which can inject any
# code into your module. It's how `use GenServer` sets up
# default callbacks.
