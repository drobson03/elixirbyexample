# URLs provide a uniform way to locate resources. The
# `URI` module parses and builds them.

# We'll parse this example URL, which includes a scheme,
# authentication info, host, port, path, query params
# and a fragment.
s = "postgres://user:pass@host.com:5432/path?k=v&tags=a&tags=b#f"
u = URI.parse(s)

IO.puts(u.scheme)
IO.puts(u.userinfo)
IO.puts(u.host)
IO.puts(u.port)
IO.puts(u.path)
IO.puts(u.fragment)

# Split the user info into username and password.
[user, pass] = String.split(u.userinfo, ":")
IO.puts("#{user} / #{pass}")

# The query string is kept raw. `URI.decode_query/1`
# turns it into a map; note repeated keys keep the last
# value.
IO.puts(u.query)
IO.inspect(URI.decode_query(u.query))

# `URI.query_decoder/1` keeps every key/value pair.
IO.inspect(URI.query_decoder(u.query) |> Enum.to_list())

# Build URLs by encoding a query and updating the struct.
query = URI.encode_query(%{q: "elixir lang", page: 2})

IO.puts(
  URI.to_string(%URI{
    scheme: "https",
    host: "example.com",
    path: "/search",
    query: query
  })
)

# Resolve relative links against a base URL.
IO.puts(URI.merge("https://example.com/docs/intro", "../api") |> to_string())

# Percent-encode arbitrary text.
IO.puts(URI.encode_www_form("a b&c=d/é"))
