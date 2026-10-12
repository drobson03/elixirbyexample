# Elixir by Example

A hands-on introduction to Elixir using annotated example programs, in the
style of [Go by Example](https://gobyexample.com).

This project (the examples, the site generator and the styling) was written
by Claude (Claude Opus 5.5, an AI model by Anthropic) using
[Claude Code](https://claude.com/claude-code).

## Building

Requires Elixir 1.18+ (uses the built-in `JSON` module).

```sh
elixir build.exs          # run every example and generate public/
elixir build.exs maps     # rebuild only examples whose slug contains "maps"
python3 -m http.server -d public 8000
```

The build **runs every example** and embeds its real output. It fails if an
example crashes, exits with an unexpected status, or prints a compiler warning.

## Adding an example

1. Add a title to `examples.txt` (its position sets the order).
2. Create `examples/<slug>.exs`, where the slug is the lowercased title with
   non-alphanumerics replaced by `-` (e.g. `Try, Catch and After` →
   `try-catch-and-after.exs`).
3. Write comments (`# ...`) for the prose column and code for the right column.
   A comment block starts a new row when it follows code or a blank line.

Special comment lines (all stripped from the displayed source):

| Line              | Meaning                                           |
| ----------------- | ------------------------------------------------- |
| `# @args: a b c`  | Command-line arguments used when running it       |
| `# @env: FOO=bar` | Environment variables used when running it        |
| `# @exit: 3`      | The example is expected to exit with this status  |
| `# $ text`        | Prose shown next to the program's output          |

Run `mix format` to keep examples at 80 columns (see `.formatter.exs`).

Note: Elixir 1.20 compiles a whole script before running it, so a struct
literal or an imported macro/sigil can't be used at the top level of the same
file that defines it. Put that code in a module (see `structs.exs`).
