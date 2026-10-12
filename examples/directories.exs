# Elixir has several useful functions for working with
# directories in the file system.

# Create a new sub-directory in a temporary location.
base = Path.join(System.tmp_dir!(), "subdir")
File.rm_rf!(base)
File.mkdir!(base)

# `File.mkdir_p!/1` creates a hierarchy of directories,
# including parents, like `mkdir -p`.
File.mkdir_p!(Path.join([base, "parent", "child"]))

# Create some empty files with `File.touch!/1`.
File.touch!(Path.join(base, "file1"))
File.touch!(Path.join([base, "parent", "file2"]))
File.touch!(Path.join([base, "parent", "file3"]))
File.touch!(Path.join([base, "parent", "child", "file4"]))

# `File.ls!/1` lists a directory's contents.
IO.inspect(File.ls!(Path.join(base, "parent")) |> Enum.sort())

# `File.dir?/1` and `File.regular?/1` tell entries apart.
for name <- Enum.sort(File.ls!(Path.join(base, "parent"))) do
  full = Path.join([base, "parent", name])
  IO.puts("  #{name} dir? #{File.dir?(full)}")
end

# `File.cd!/2` runs a function with a different working
# directory, then changes back.
File.cd!(Path.join(base, "parent"), fn ->
  IO.inspect(File.ls!("child"))
end)

# Walk a whole tree recursively with `**` globs.
base
|> Path.join("**")
|> Path.wildcard()
|> Enum.map(&Path.relative_to(&1, base))
|> Enum.sort()
|> Enum.each(&IO.puts("visit: #{&1}"))

# `File.rm_rf!/1` deletes a whole tree, like `rm -rf`.
File.rm_rf!(base)
IO.puts(File.exists?(base))
