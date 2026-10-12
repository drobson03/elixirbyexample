# Structs are maps with a fixed set of fields, default
# values, and a name. They're defined inside a module
# with `defstruct`.

defmodule User do
  # `@enforce_keys` makes some fields required.
  @enforce_keys [:name]
  defstruct [:name, age: 0, admin: false]
end

# Struct literals are expanded at compile time, so they
# can only be used once the struct's module has been
# compiled. In a script we put our code in a module that
# comes after it.
defmodule Main do
  def run do
    # Create a struct with `%User{...}`. Fields you leave
    # out get their defaults.
    ada = %User{name: "Ada", age: 36}
    IO.inspect(ada)
    IO.inspect(%User{name: "Bob"})

    # Access fields with dot notation.
    IO.puts(ada.name)

    # Update with the map update syntax. Structs are
    # immutable, so this returns a new struct.
    older = %{ada | age: 37}
    IO.puts(older.age)

    # Structs can be pattern matched, which lets functions
    # only accept the struct they expect.
    IO.puts(greet(ada))
    IO.puts(greet(%User{name: "Root", admin: true}))

    # A struct is really a map with a special `__struct__`
    # key, but it doesn't support map features like `[]`
    # access or the `Enum` protocol unless you implement
    # them.
    IO.puts(is_map(ada))
    IO.inspect(ada.__struct__)
    IO.inspect(Map.from_struct(ada))

    # Unknown fields are rejected: at compile time when
    # they appear in a literal, and at runtime by
    # `struct!/2`.
    try do
      struct!(User, name: "Eve", email: "eve@example.com")
    rescue
      e in KeyError -> IO.puts("error: unknown key #{inspect(e.key)}")
    end
  end

  defp greet(%User{name: name, admin: true}), do: "Welcome back, admin #{name}"
  defp greet(%User{name: name}), do: "Hi #{name}"
end

Main.run()
