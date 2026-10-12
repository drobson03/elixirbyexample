# SHA256 hashes are frequently used to compute short
# identities for binary or text blobs. Elixir uses
# Erlang's `:crypto` module for hashing.

s = "sha256 this string"

# `:crypto.hash/2` returns the raw digest as a binary.
digest = :crypto.hash(:sha256, s)
IO.inspect(byte_size(digest))

# Encode it as hex for display. `Base.encode16/2` does
# the job.
IO.puts(Base.encode16(digest, case: :lower))

# Other algorithms work the same way.
IO.puts(:crypto.hash(:md5, s) |> Base.encode16(case: :lower))

IO.puts(
  :crypto.hash(:sha512, s)
  |> Base.encode16(case: :lower)
  |> binary_part(0, 32)
)

# For large inputs, hash incrementally: initialise a
# context, update it with chunks, then finalise.
digest2 =
  :crypto.hash_init(:sha256)
  |> :crypto.hash_update("sha256 ")
  |> :crypto.hash_update("this string")
  |> :crypto.hash_final()

IO.puts(digest2 == digest)

# HMACs combine a hash with a secret key, for example to
# sign webhooks.
IO.puts(
  :crypto.mac(:hmac, :sha256, "secret-key", s)
  |> Base.encode16(case: :lower)
)
