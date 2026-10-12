# The pipe operator `|>` passes the result of one
# expression as the *first argument* of the next function
# call. It turns nested calls inside-out so data flows
# top to bottom.

# Nested calls read from the inside out...
IO.puts(String.upcase(String.reverse(String.trim("  hello  "))))

# ...while pipes read in the order things happen.
"  hello  "
|> String.trim()
|> String.reverse()
|> String.upcase()
|> IO.puts()

# Pipes shine for data transformations. Find the sum of
# the squares of the odd numbers from 1 to 10:
1..10
|> Enum.filter(&(rem(&1, 2) == 1))
|> Enum.map(&(&1 * &1))
|> Enum.sum()
|> IO.puts()

# `IO.inspect/2` returns its argument unchanged, so you
# can drop it into the middle of a pipeline to debug.
"the quick brown fox"
|> String.split()
|> IO.inspect(label: "words")
|> Enum.map(&String.capitalize/1)
|> Enum.join(" ")
|> IO.puts()

# `then/2` lets you pipe into a function where the value
# isn't the first argument.
5
|> then(&Integer.pow(2, &1))
|> IO.puts()
