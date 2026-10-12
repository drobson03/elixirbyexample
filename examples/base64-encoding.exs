# The `Base` module provides base64, base32 and base16
# (hex) encoding and decoding.

data = "abc123!?$*&()'-=@~"

# Standard base64 encoding.
s = Base.encode64(data)
IO.puts(s)

# Decoding returns `{:ok, binary}`, or `:error` for
# invalid input. The `!` version raises instead.
IO.inspect(Base.decode64(s))
IO.inspect(Base.decode64("not base64!"))

# URL-safe base64 uses `-` and `_` instead of `+` and
# `/`, so it's safe in URLs and filenames.
u = Base.url_encode64(data)
IO.puts(u)
IO.puts(Base.url_decode64!(u))

# Padding (`=`) can be dropped.
IO.puts(Base.encode64("hi"))
IO.puts(Base.encode64("hi", padding: false))

# Hex and base32 work the same way.
IO.puts(Base.encode16("hi"))
IO.puts(Base.encode32("hi"))
IO.puts(Base.decode16!("6869"))
