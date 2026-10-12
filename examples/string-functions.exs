# The `String` module provides many useful string
# functions. They're all Unicode-aware.

p = &IO.inspect/2

p.(String.contains?("test", "es"), label: "Contains")
p.(String.starts_with?("test", "te"), label: "StartsWith")
p.(String.ends_with?("test", "st"), label: "EndsWith")
p.(String.split("test", "t") |> length() |> Kernel.-(1), label: "Count")
p.(:binary.match("test", "e"), label: "Index")
p.(Enum.join(["a", "b"], "-"), label: "Join")
p.(String.duplicate("a", 5), label: "Repeat")
p.(String.replace("foo", "o", "0"), label: "Replace")
p.(String.replace("foo", "o", "0", global: false), label: "Replace once")
p.(String.split("a-b-c-d-e", "-"), label: "Split")
p.(String.downcase("TEST"), label: "ToLower")
p.(String.upcase("test"), label: "ToUpper")
p.(String.capitalize("hELLO"), label: "Capitalize")
p.(String.trim("  padded  "), label: "Trim")
p.(String.pad_leading("42", 5, "0"), label: "PadLeading")
p.(String.reverse("stressed"), label: "Reverse")
p.(String.slice("hello world", 6..-1//1), label: "Slice")
p.(String.at("hello", 1), label: "At")

# Unicode is handled correctly: these functions work on
# graphemes, not bytes.
p.(String.reverse("noël"), label: "Reverse unicode")
p.(String.graphemes("🇯🇵ok"), label: "Graphemes")
p.(String.codepoints("é"), label: "Codepoints")
p.(String.upcase("straße"), label: "Upcase unicode")
