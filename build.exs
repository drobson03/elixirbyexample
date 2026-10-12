# Builds the Elixir by Example site into ./public.
#
#   elixir build.exs            # build everything
#   elixir build.exs maps       # build only examples whose slug contains "maps"
#
# Each example lives in examples/<slug>.exs. Comment lines (`# ...`) become the
# prose column; everything else is code. Special comment prefixes:
#
#   # @args: a b c     extra command-line arguments when running the example
#   # @env: FOO=bar    environment variables when running the example
#   # @exit: 3         the example is expected to exit with this status
#   # $ some text      prose shown next to the program's output
#
# These forms survive `mix format`, which normalises comments to `# `.
#
# Every example is executed at build time and its real output is embedded.

defmodule Site.Highlight do
  @keywords ~w(def defp defmodule defstruct defprotocol defimpl defmacro defmacrop
               defguard defdelegate defexception do end fn case cond if else with
               receive after try rescue catch for when in not and or raise reraise
               import alias require use quote unquote true false nil throw)

  @classes [
    "c",
    "s",
    "s",
    "s",
    "a",
    "attr",
    "m",
    "k",
    nil,
    "n",
    "n"
  ]

  @token_re Regex.compile!(
              Enum.join(
                [
                  # comment
                  ~S'(#.*)',
                  # heredoc
                  ~S'("""[\s\S]*?"""|' <> "'''" <> ~S'[\s\S]*?' <> "'''" <> ")",
                  # sigils
                  ~S'(~[a-zA-Z]+(?:"""[\s\S]*?"""|"(?:\\.|[^"\\])*"|/(?:\\.|[^/\\\n])*/|\|[^|\n]*\||\([^)\n]*\)|\[[^\]\n]*\]|\{[^}\n]*\}|<[^>\n]*>)[a-zA-Z]*)',
                  # strings & charlists
                  ~S'("(?:\\.|#\{[^}]*\}|[^"\\])*"|' <>
                    "'(?:\\\\.|[^'\\\\\\n])*'" <> ")",
                  # atoms & keyword keys
                  ~S'(:"(?:\\.|[^"\\])*"|(?<![:\w]):[a-zA-Z_][\w]*[?!]?|(?<![:\w])[a-zA-Z_][\w]*[?!]?:(?=\s))',
                  # module attributes
                  ~S'(@[a-z_]\w*)',
                  # module names
                  ~S'(\b[A-Z][\w]*)',
                  # keywords
                  "(\\b(?:" <> Enum.join(@keywords, "|") <> ")\\b(?![?!:]))",
                  # plain identifiers (so `valid?` isn't read as a char literal)
                  ~S'(\b[a-z_][\w]*[?!]?)',
                  # numbers
                  ~S'(\b0x[0-9a-fA-F_]+|\b0b[01_]+|\b\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][-+]?\d+)?)',
                  # char literals
                  ~S'(\?(?:\\.|[^\s]))'
                ],
                "|"
              ),
              "u"
            )

  def highlight(code) do
    matches = Regex.scan(@token_re, code, return: :index)

    {parts, pos} =
      Enum.reduce(matches, {[], 0}, fn [{start, len} | groups], {acc, pos} ->
        idx = Enum.find_index(groups, fn {s, _} -> s >= 0 end)
        class = Enum.at(@classes, idx)
        before = binary_part(code, pos, start - pos)
        token = escape(binary_part(code, start, len))

        token =
          if class, do: ~s(<span class="#{class}">#{token}</span>), else: token

        {[token, escape(before) | acc], start + len}
      end)

    rest = binary_part(code, pos, byte_size(code) - pos)
    IO.iodata_to_binary(Enum.reverse([escape(rest) | parts]))
  end

  def escape(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
  end
end

defmodule Site.Markdown do
  import Site.Highlight, only: [escape: 1]

  # A deliberately tiny markdown: paragraphs, `code`, [links](url), *emphasis*.
  def render(lines) do
    lines
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""] or Enum.all?(&1, fn l -> l == "" end)))
    |> Enum.map_join("\n", fn para ->
      "<p>" <> inline(Enum.join(para, " ")) <> "</p>"
    end)
  end

  defp inline(text) do
    text
    |> escape()
    |> then(&Regex.replace(~r/`([^`]+)`/, &1, "<code>\\1</code>"))
    |> then(
      &Regex.replace(~r/\[([^\]]+)\]\(([^)]+)\)/, &1, ~s(<a href="\\2">\\1</a>))
    )
    |> then(
      &Regex.replace(
        ~r/(?<![\w*])\*([^*\s][^*]*)\*(?![\w*])/,
        &1,
        "<em>\\1</em>"
      )
    )
  end
end

defmodule Site.Example do
  defstruct [
    :title,
    :slug,
    :source,
    :segments,
    :output_docs,
    :args,
    :env,
    :exit,
    :output
  ]

  @directive_re ~r/^# @(args|env|exit):(.*)$/

  def load(title) do
    slug = slugify(title)
    path = Path.join("examples", slug <> ".exs")
    raw = File.read!(path)
    lines = String.split(String.trim_trailing(raw), "\n")

    directives =
      for line <- lines,
          [_, k, v] <- [Regex.run(@directive_re, line)],
          into: %{},
          do: {k, String.trim(v)}

    output_docs = for "# $" <> rest <- lines, do: String.trim(rest)

    body =
      Enum.reject(
        lines,
        &(&1 =~ @directive_re or String.starts_with?(&1, "# $"))
      )

    %__MODULE__{
      title: title,
      slug: slug,
      source: Enum.join(body, "\n") <> "\n",
      segments: segment(body),
      output_docs: output_docs,
      args: Map.get(directives, "args", ""),
      env: Map.get(directives, "env", ""),
      exit: String.to_integer(Map.get(directives, "exit", "0"))
    }
  end

  def slugify(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end

  # Split the file into [{doc_lines, code_lines}] pairs, Go-by-Example style.
  defp segment(lines) do
    {segs, _} =
      Enum.reduce(lines, {[{[], []}], false}, fn line,
                                                 {[{docs, code} | rest] = segs,
                                                  heredoc?} ->
        trimmed = String.trim_leading(line)

        doc? =
          not heredoc? and
            (trimmed == "#" or String.starts_with?(trimmed, "# "))

        cond do
          doc? ->
            text =
              trimmed
              |> String.trim_leading("#")
              |> String.replace_prefix(" ", "")

            # A comment after code, or after a blank line, starts a new row.
            if code != [] do
              {[{[text], []} | segs], heredoc?}
            else
              {[{docs ++ [text], code} | rest], heredoc?}
            end

          true ->
            quotes = length(Regex.scan(~r/"""|'''/, line))
            toggle = rem(quotes, 2) == 1

            {[{docs, code ++ [line]} | rest],
             if(toggle, do: not heredoc?, else: heredoc?)}
        end
      end)

    segs
    |> Enum.reverse()
    |> Enum.map(fn {docs, code} -> {docs, trim_blank(code)} end)
    |> Enum.reject(fn {docs, code} -> docs == [] and code == [] end)
  end

  defp trim_blank(lines) do
    lines
    |> Enum.drop_while(&(String.trim(&1) == ""))
    |> Enum.reverse()
    |> Enum.drop_while(&(String.trim(&1) == ""))
    |> Enum.reverse()
  end

  def run(%__MODULE__{} = ex) do
    args = if ex.args == "", do: [], else: String.split(ex.args)

    env =
      if ex.env == "",
        do: [],
        else:
          for(
            pair <- String.split(ex.env),
            do: List.to_tuple(String.split(pair, "=", parts: 2))
          )

    {out, status} =
      System.cmd("elixir", [ex.slug <> ".exs" | args],
        cd: "examples",
        env: env,
        stderr_to_stdout: true
      )

    cond do
      status != ex.exit ->
        raise "#{ex.slug}: expected exit #{ex.exit}, got #{status}\n#{out}"

      out =~ ~r/warning:|\(CompileError\)|\*\* \(/ and
          not String.contains?(ex.source, "** (") ->
        raise "#{ex.slug}: unexpected warning/error in output\n#{out}"

      true ->
        %{ex | output: out}
    end
  end
end

defmodule Site.Render do
  import Site.Highlight, only: [escape: 1, highlight: 1]

  @site "Elixir by Example"

  def page(ex, prev, next) do
    rows =
      ex.segments
      |> Enum.with_index()
      |> Enum.map_join("\n", fn {{docs, code}, i} ->
        code_html =
          if code == [],
            do: "",
            else:
              "<pre class=\"chroma\"><code>#{highlight(Enum.join(code, "\n"))}</code></pre>"

        copy =
          if i == 0,
            do:
              ~s(<button class="copy" title="Copy source" aria-label="Copy source">copy</button>),
            else: ""

        classes =
          Enum.join(
            Enum.reject(
              ["code", code == [] && "empty", i == 0 && "leading"],
              &(!&1)
            ),
            " "
          )

        """
        <tr>
          <td class="docs">#{Site.Markdown.render(docs)}</td>
          <td class="#{classes}">#{copy}#{code_html}</td>
        </tr>
        """
      end)

    env_prefix = if ex.env == "", do: "", else: ex.env <> " "
    args_suffix = if ex.args == "", do: "", else: " " <> ex.args

    command =
      "<span class=\"prompt\">$</span> <span class=\"cmd\">#{escape(env_prefix)}elixir #{ex.slug}.exs#{escape(args_suffix)}</span>"

    exit_lines =
      if ex.exit != 0,
        do:
          "\n<span class=\"prompt\">$</span> <span class=\"cmd\">echo $?</span>\n#{ex.exit}",
        else: ""

    output_text = String.trim_trailing(ex.output)

    output_html =
      command <>
        if(output_text == "", do: "", else: "\n" <> escape(output_text)) <>
        exit_lines

    output_docs =
      if ex.output_docs == [],
        do: "<p>Run it:</p>",
        else: Site.Markdown.render(ex.output_docs)

    nav = fn
      nil, _ -> ""
      e, rel -> ~s(<link rel="#{rel}" href="#{e.slug}.html">)
    end

    next_html =
      if next,
        do:
          ~s(<p class="next">Next example: <a href="#{next.slug}.html">#{escape(next.title)}</a>.</p>),
        else:
          ~s(<p class="next">That's all! Back to the <a href="index.html">index</a>.</p>)

    layout(
      "#{@site}: #{ex.title}",
      nav.(prev, "prev") <> nav.(next, "next"),
      """
      <div class="example" id="#{ex.slug}">
        <h2><a href="index.html">#{@site}</a>: #{escape(ex.title)}</h2>
        <table class="segments">
      #{rows}
        </table>
        <table class="segments output">
          <tr>
            <td class="docs">#{output_docs}</td>
            <td class="code shell"><pre><code>#{output_html}</code></pre></td>
          </tr>
        </table>
        #{next_html}
        #{footer()}
      </div>
      <script>
        const SOURCE = #{json_for_script(ex.source)};
        const PREV = #{json_for_script(prev && prev.slug <> ".html")};
        const NEXT = #{json_for_script(next && next.slug <> ".html")};
      </script>
      <script src="site.js"></script>
      """
    )
  end

  def index(examples) do
    items =
      Enum.map_join(examples, "\n", fn ex ->
        ~s(    <li><a href="#{ex.slug}.html">#{escape(ex.title)}</a></li>)
      end)

    layout(@site, "", """
    <div id="intro">
      <h2>#{@site}</h2>
      <p>
        <a href="https://elixir-lang.org">Elixir</a> is a dynamic, functional
        language for building scalable and maintainable applications. It runs on
        the Erlang VM, known for low-latency, distributed, and fault-tolerant systems.
      </p>
      <p>
        <em>Elixir by Example</em> is a hands-on introduction to Elixir using
        annotated example programs. Check out the <a href="#{hd(examples).slug}.html">first example</a>
        or browse the full list below.
      </p>
      <p>
        Unless stated otherwise, examples here assume the
        <a href="https://elixir-lang.org/install.html">latest major release of Elixir</a>.
        Every example is a standalone script you can run with <code>elixir</code>, and the output
        shown on each page was produced by actually running it.
      </p>
      <ul class="toc">
    #{items}
      </ul>
      #{footer()}
    </div>
    <script>const PREV = null, NEXT = #{json_for_script(hd(examples).slug <> ".html")}, SOURCE = null;</script>
    <script src="site.js"></script>
    """)
  end

  defp footer do
    ~s(<p class="footer">Inspired by <a href="https://gobyexample.com">Go by Example</a>. Written by <a href="https://claude.com/claude-code">Claude</a> \(Claude Opus 5.5, an AI model by Anthropic\). Built with Elixir #{System.version()}.</p>)
  end

  defp layout(title, head_extra, body) do
    """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>#{escape(title)}</title>
      <link rel="stylesheet" href="site.css">
      <link rel="icon" href="favicon.svg" type="image/svg+xml">
      #{head_extra}
    </head>
    <body>
    #{body}
    </body>
    </html>
    """
  end

  defp json_for_script(value),
    do: value |> JSON.encode!() |> String.replace("</", "<\\/")
end

filter = List.first(System.argv())

examples =
  "examples.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.trim/1)
  |> Enum.reject(&(&1 == "" or String.starts_with?(&1, "#")))
  |> Enum.filter(fn title ->
    path = "examples/#{Site.Example.slugify(title)}.exs"

    File.exists?(path) or
      (IO.puts(:stderr, "skipping #{title}: #{path} not found") && false)
  end)
  |> Enum.map(&Site.Example.load/1)

to_run =
  if filter,
    do: Enum.filter(examples, &String.contains?(&1.slug, filter)),
    else: examples

results =
  to_run
  |> Task.async_stream(
    fn ex ->
      try do
        {:ok, Site.Example.run(ex)}
      rescue
        e -> {:error, ex.slug, Exception.message(e)}
      end
    end,
    max_concurrency: System.schedulers_online(),
    timeout: 60_000,
    ordered: true
  )
  |> Enum.map(fn {:ok, r} -> r end)

failures = for {:error, slug, msg} <- results, do: {slug, msg}

for {slug, msg} <- failures do
  IO.puts(
    :stderr,
    IO.ANSI.red() <> "✗ #{slug}" <> IO.ANSI.reset() <> "\n" <> msg
  )
end

if failures != [], do: System.halt(1)

ran = Map.new(for {:ok, ex} <- results, do: {ex.slug, ex})
File.mkdir_p!("public")

examples
|> Enum.with_index()
|> Enum.each(fn {ex, i} ->
  case ran[ex.slug] do
    nil ->
      :skip

    ex ->
      prev = if i > 0, do: Enum.at(examples, i - 1)
      next = Enum.at(examples, i + 1)
      File.write!("public/#{ex.slug}.html", Site.Render.page(ex, prev, next))
  end
end)

File.write!("public/index.html", Site.Render.index(examples))

for asset <- ~w(site.css site.js favicon.svg),
    do: File.cp!("templates/#{asset}", "public/#{asset}")

IO.puts("Built #{map_size(ran)} of #{length(examples)} examples into public/")
