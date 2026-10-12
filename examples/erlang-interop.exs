# Elixir runs on the Erlang VM and can call any Erlang
# module directly, with no wrappers or overhead. Erlang
# modules are written as atoms, like `:math`.

IO.puts(:math.pi())
IO.puts(:math.sqrt(16))
IO.puts(:math.log2(1024))

# Erlang's standard library fills gaps in Elixir's. For
# example, `:timer.tc/1` times a function...
{micros, sum} = :timer.tc(fn -> Enum.sum(1..1_000_000) end)
IO.puts("sum #{sum} took #{micros}µs")

# ...`:queue` is an efficient FIFO queue...
q = :queue.new() |> then(&:queue.in(1, &1)) |> then(&:queue.in(2, &1))
{{:value, first}, _q} = :queue.out(q)
IO.puts("dequeued #{first}")

# ...and `:gb_trees` / `:gb_sets` are sorted, balanced
# trees.
tree = Enum.reduce([5, 1, 3], :gb_sets.new(), &:gb_sets.add/2)
IO.inspect(:gb_sets.to_list(tree))

# Erlang strings are charlists, so convert when crossing
# the boundary.
IO.inspect(:string.uppercase(~c"hello"))
IO.inspect(:os.type())
IO.inspect(List.to_string(:erlang.system_info(:otp_release)))

# Erlang functions use the same data types: atoms,
# tuples, lists, binaries and maps all pass through
# unchanged.
IO.inspect(:lists.zip([1, 2], [:a, :b]))
IO.inspect(:maps.merge(%{a: 1}, %{b: 2}))

# The whole Erlang ecosystem, including OTP libraries
# like `:crypto`, `:ssl`, `:ets` and `:observer`, is
# available to Elixir programs. Erlang packages on Hex can
# be added to a Mix project like any other dependency.
