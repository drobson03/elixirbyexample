# Elixir uses Erlang's `:rand` module for random numbers,
# plus convenient helpers in `Enum`.

# `:rand.uniform/1` returns an integer from 1 to N
# inclusive.
IO.puts("#{:rand.uniform(100)}, #{:rand.uniform(100)}")

# `:rand.uniform/0` returns a float in `0.0 <= f < 1.0`.
IO.puts(:rand.uniform())

# Scale floats to another range, e.g. `5.0 <= f < 10.0`.
IO.puts(:rand.uniform() * 5 + 5)

# Pick random elements and shuffle collections.
IO.inspect(Enum.random(1..6))
IO.inspect(Enum.random(~w(rock paper scissors)))
IO.inspect(Enum.shuffle([1, 2, 3, 4, 5]))
# Lists of small integers may be printed as charlists by
# `IO.inspect`; `charlists: :as_lists` avoids surprises.
IO.inspect(Enum.take_random(1..100, 3), charlists: :as_lists)

# Seeding the generator with a fixed value gives the same
# sequence every time. The seed is stored per process.
:rand.seed(:exsss, {42, 42, 42})
first = for _ <- 1..3, do: :rand.uniform(1000)

:rand.seed(:exsss, {42, 42, 42})
second = for _ <- 1..3, do: :rand.uniform(1000)

IO.inspect(first)
IO.puts(first == second)

# For anything security-related, such as tokens or keys,
# use cryptographically strong bytes instead.
IO.puts(:crypto.strong_rand_bytes(16) |> Base.url_encode64(padding: false))
