# Writing files follows similar patterns to reading.
dir = System.tmp_dir!()

# `File.write!/2` writes a whole file at once, replacing
# any existing contents.
path1 = Path.join(dir, "dat1")
File.write!(path1, "hello\nelixir\n")
IO.write(File.read!(path1))

# Append instead of replacing with the `:append` mode.
File.write!(path1, "appended\n", [:append])
IO.write(File.read!(path1))

# For many writes, open the file once and write to the
# device. `File.open/3` with a function closes the file
# automatically when the function returns.
path2 = Path.join(dir, "dat2")

File.open!(path2, [:write, :utf8], fn file ->
  IO.write(file, "some\n")
  IO.puts(file, "writes")

  # `IO.binwrite/2` writes raw bytes.
  IO.binwrite(file, "buffered\n")
end)

IO.write(File.read!(path2))

# Writing accepts *iodata*: nested lists of strings and
# bytes. They're written without being concatenated
# first, which is efficient for building large output.
path3 = Path.join(dir, "dat3")
File.write!(path3, ["line ", ["one", ?\n], "line two\n"])
IO.write(File.read!(path3))

# `File.stream!/1` can also be a destination for a
# stream, writing lines as they're produced.
1..3
|> Stream.map(&"row #{&1}\n")
|> Enum.into(File.stream!(path3))

IO.write(File.read!(path3))

Enum.each([path1, path2, path3], &File.rm!/1)
