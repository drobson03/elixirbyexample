# Reading files is a basic task in many programs. Let's
# look at some ways to do it. First we write a sample
# file to read.
path = Path.join(System.tmp_dir!(), "dat")
File.write!(path, "hello\nelixir\n")

# `File.read/1` slurps a whole file into memory. It
# returns `{:ok, contents}` or `{:error, reason}`.
{:ok, contents} = File.read(path)
IO.inspect(contents)

# `File.read!/1` returns the contents directly and raises
# on error, which is convenient when failure is a bug.
IO.write(File.read!(path))

# Errors use POSIX reason atoms like `:enoent`
# (no such file) or `:eacces` (permission denied).
IO.inspect(File.read("/no/such/file"))

# For more control, open the file and read from the
# device. Here we read the first 5 bytes, then a line.
{:ok, file} = File.open(path, [:read])
IO.inspect(IO.binread(file, 5))
IO.inspect(IO.binread(file, :line))
File.close(file)

# `File.stream!/1` reads lazily, line by line, which
# lets you process huge files in constant memory.
path
|> File.stream!()
|> Stream.map(&String.trim/1)
|> Stream.with_index(1)
|> Enum.each(fn {line, n} -> IO.puts("#{n}: #{line}") end)

# Check for existence and file details.
IO.puts(File.exists?(path))
IO.puts(File.stat!(path).size)

File.rm!(path)
