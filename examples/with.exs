# `with` chains together a sequence of pattern matches. If
# every step matches, the `do` block runs. If any step
# fails to match, `with` stops and returns the
# non-matching value (or hands it to `else`).

defmodule Signup do
  def validate_name(""), do: {:error, :name_missing}
  def validate_name(name), do: {:ok, name}

  def validate_age(age) when age >= 18, do: {:ok, age}
  def validate_age(_), do: {:error, :too_young}

  # Each `<-` clause must match for the chain to continue.
  # Plain `=` clauses can be mixed in too.
  def register(params) do
    with {:ok, name} <- validate_name(params[:name]),
         {:ok, age} <- validate_age(params[:age]),
         greeting = "Welcome, #{name} (#{age})!" do
      {:ok, greeting}
    end
  end

  # An `else` block lets you match the failures and
  # transform them.
  def register_friendly(params) do
    with {:ok, name} <- validate_name(params[:name]),
         {:ok, _age} <- validate_age(params[:age]) do
      "Welcome, #{name}!"
    else
      {:error, :name_missing} -> "Please tell us your name."
      {:error, :too_young} -> "Sorry, you must be 18 or older."
    end
  end
end

IO.inspect(Signup.register(%{name: "Ada", age: 36}))
IO.inspect(Signup.register(%{name: "", age: 36}))
IO.inspect(Signup.register(%{name: "Tim", age: 12}))

IO.puts(Signup.register_friendly(%{name: "", age: 40}))
IO.puts(Signup.register_friendly(%{name: "Tim", age: 12}))
