# Define your own exception with `defexception`. An
# exception is a struct with a `message` field (or a
# `message/1` callback).

defmodule InsufficientFundsError do
  defexception [:balance, :amount]

  # Implement `message/1` to build the message from the
  # exception's fields.
  @impl true
  def message(%{balance: balance, amount: amount}) do
    "cannot withdraw #{amount}, balance is only #{balance}"
  end
end

# Simpler exceptions can set a default `message`.
defmodule AccountLockedError do
  defexception message: "account is locked"
end

defmodule Bank do
  def withdraw!(_balance, _amount, locked: true), do: raise(AccountLockedError)

  def withdraw!(balance, amount, _opts) when amount > balance do
    raise InsufficientFundsError, balance: balance, amount: amount
  end

  def withdraw!(balance, amount, _opts), do: balance - amount
end

IO.puts(Bank.withdraw!(100, 30, locked: false))

# Rescue by type and read the exception's fields.
for {amount, opts} <- [{500, [locked: false]}, {10, [locked: true]}] do
  try do
    Bank.withdraw!(100, amount, opts)
  rescue
    e in InsufficientFundsError ->
      IO.puts("#{Exception.message(e)} (short by #{e.amount - e.balance})")

    e in AccountLockedError ->
      IO.puts("locked: " <> e.message)
  end
end

# You can override the default message when raising.
try do
  raise AccountLockedError, message: "locked for maintenance"
rescue
  e -> IO.puts(e.message)
end
