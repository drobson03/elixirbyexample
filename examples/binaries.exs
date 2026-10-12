# A *binary* is a sequence of bytes, written between
# `<<` and `>>`. Strings are binaries holding UTF-8 text.

bin = <<104, 101, 108, 108, 111>>
IO.inspect(bin)
IO.puts(is_binary("hello"))
IO.puts(byte_size(bin))

# Each segment can have a size and type. Here we pack a
# 16-bit and a 32-bit integer.
packed = <<1::16, 500::32>>
IO.inspect(packed)

# Pattern matching on binaries makes parsing binary
# formats easy. Let's decode that packed data back out.
<<a::16, b::32>> = packed
IO.inspect({a, b})

# Match a fixed-size header and keep the rest with
# `::binary`.
<<header::binary-size(3), rest::binary>> = "GIF89a..."
IO.inspect({header, rest})

# Endianness, signedness and floats are all supported.
IO.inspect(<<258::little-16>>)
<<f::float-32>> = <<1.5::float-32>>
IO.inspect(f)

# `::utf8` matches a single Unicode code point, which can
# be several bytes.
<<first::utf8, _::binary>> = "über"
IO.inspect({first, <<first::utf8>>})

# A *bitstring* is like a binary, but its length doesn't
# have to be a multiple of 8 bits.
bits = <<5::3>>
IO.inspect(bits)
IO.inspect(bit_size(bits))
IO.puts(is_binary(bits))
