# The `Path` module provides functions to work with file
# paths in a way that's portable between operating
# systems.

# Build paths with `Path.join/1`, rather than
# concatenating `/` by hand.
p = Path.join(["dir1", "dir2", "filename"])
IO.puts(p)

# `join` handles trailing and leading separators for
# you.
IO.puts(Path.join("dir1/", "/filename"))

# Split a path into its directory and file name.
IO.puts(Path.dirname(p))
IO.puts(Path.basename(p))

# Get and strip extensions.
filename = "config.json"
IO.puts(Path.extname(filename))
IO.puts(Path.rootname(filename))
IO.puts(Path.basename("/a/b/archive.tar.gz", ".gz"))

# Check whether a path is absolute, and expand relative
# paths (resolving `..` along the way).
IO.inspect(Path.type("dir/file"))
IO.inspect(Path.type("/dir/file"))
IO.puts(Path.expand("a/../b/./c", "/root"))

# Find a relative path between two absolute ones.
IO.puts(Path.relative_to("/a/b/t/file", "/a/b"))

# `Path.split/1` returns all components.
IO.inspect(Path.split("/usr/local/bin/elixir"))

# `Path.wildcard/1` finds files matching a glob pattern.
IO.inspect(Path.wildcard("file-*.exs"))
