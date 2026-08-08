local ls = require("luasnip")
local p = ls.parser.parse_snippet

return {
  -- for i in 0..n  (the one that bit you: remember the range!)
  p("forr", "for $1 in $2 {\n\t$0\n}"),
  -- for item in iterable
  p("forin", "for $1 in $2 {\n\t$0\n}"),
  -- function with return type
  p("fn", "fn $1($2) -> $3 {\n\t$0\n}"),
  -- main
  p("main", "fn main() {\n\t$0\n}"),
  -- match
  p("match", "match $1 {\n\t$2 => $3,\n\t_ => $4,\n}"),
  -- if let
  p("iflet", "if let $1 = $2 {\n\t$0\n}"),
  -- impl block
  p("impl", "impl $1 {\n\t$0\n}"),
  -- struct
  p("struct", "struct $1 {\n\t$2: $3,\n}"),
  -- enum
  p("enum", "enum $1 {\n\t$2,\n}"),
  -- vec!
  p("vec", "vec![$1]"),
  -- println!
  p("pr", "println!(\"$1\", $2);"),
  -- derive
  p("der", "#[derive($1)]"),
}
