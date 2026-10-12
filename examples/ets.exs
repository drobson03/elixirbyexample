# ETS (Erlang Term Storage) provides fast, in-memory
# key-value tables that can be shared between processes.
# It's built into the VM and accessed through the Erlang
# `:ets` module.

# Create a named table. `:set` means one value per key;
# `:public` lets any process read and write it.
:ets.new(:cache, [:set, :public, :named_table])

# Rows are tuples; the first element is the key.
:ets.insert(:cache, {"alice", 31, :admin})
:ets.insert(:cache, [{"bob", 25, :user}, {"carol", 47, :user}])

# `lookup/2` returns a list of matching rows.
IO.inspect(:ets.lookup(:cache, "alice"))
IO.inspect(:ets.lookup(:cache, "nobody"))

# Inserting an existing key overwrites it in a `:set`.
:ets.insert(:cache, {"bob", 26, :user})
IO.inspect(:ets.lookup_element(:cache, "bob", 2))

# Atomic counters with `update_counter/3`.
:ets.insert(:cache, {:hits, 0})
for _ <- 1..5, do: :ets.update_counter(:cache, :hits, 1)
IO.inspect(:ets.lookup(:cache, :hits))

# Query with match patterns: `:"$1"` captures a field and
# `:_` ignores one.
IO.inspect(:ets.match(:cache, {:"$1", :_, :user}) |> Enum.sort())

# Other processes can read the table too.
Task.async(fn -> :ets.lookup(:cache, "carol") end)
|> Task.await()
|> IO.inspect()

:ets.delete(:cache, "alice")
IO.puts(:ets.info(:cache, :size))

# A table is owned by the process that created it and is
# deleted when that process exits.
