; SQL highlighting for SQLX
(call_expression
  (scoped_identifier
    path: (identifier) @_path
    (#eq? @_path "sqlx")
    name: (identifier) @_name
    (#any-of? @_name "query" "query_as"))
  (arguments
    (raw_string_literal) @injection.content
    (#offset! @injection.content 0 3 0 -2)
    (#set! injection.language "sql")))

(call_expression
  (scoped_identifier
    path: (identifier) @_path
    (#eq? @_path "sqlx")
    name: (identifier) @_name
    (#any-of? @_name "query" "query_as"))
  (arguments
    (string_literal) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql")))

(macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    (#eq? @_path "sqlx")
    name: (identifier) @_name
    (#any-of? @_name "query" "query_as"))
  (token_tree
    (string_literal) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql")))

(macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    (#eq? @_path "sqlx")
    name: (identifier) @_name
    (#any-of? @_name "query" "query_as"))
  (token_tree
    (raw_string_literal) @injection.content
    (#offset! @injection.content 0 3 0 -2)
    (#set! injection.language "sql")))

; From upstream
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/rust/injections.scm
(macro_invocation
  macro: [
    (scoped_identifier
      name: (_) @_macro_name)
    (identifier) @_macro_name
  ]
  (token_tree) @injection.content
  (#not-eq? @_macro_name "slint")
  (#set! injection.language "rust")
  (#set! injection.include-children))

(macro_invocation
  macro: [
    (scoped_identifier
      name: (_) @_macro_name)
    (identifier) @_macro_name
  ]
  (token_tree) @injection.content
  (#eq? @_macro_name "slint")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "slint")
  (#set! injection.include-children))

(macro_definition
  (macro_rule
    left: (token_tree_pattern) @injection.content
    (#set! injection.language "rust")))

(macro_definition
  (macro_rule
    right: (token_tree) @injection.content
    (#set! injection.language "rust")))

([
  (line_comment)
  (block_comment)
] @injection.content
  (#set! injection.language "comment"))

((macro_invocation
  macro: (identifier) @injection.language
  (token_tree) @injection.content)
  (#any-of? @injection.language "html" "json"))

(call_expression
  function: (scoped_identifier
    path: (identifier) @_regex
    (#any-of? @_regex "Regex" "ByteRegexBuilder")
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal) @injection.content)
  (#set! injection.language "regex"))

(call_expression
  function: (scoped_identifier
    path: (scoped_identifier
      (identifier) @_regex
      (#any-of? @_regex "Regex" "ByteRegexBuilder") .)
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal) @injection.content)
  (#set! injection.language "regex"))

(call_expression
  function: (scoped_identifier
    path: (identifier) @_regex
    (#any-of? @_regex "RegexSet" "RegexSetBuilder")
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (array_expression
      (raw_string_literal) @injection.content))
  (#set! injection.language "regex"))

(call_expression
  function: (scoped_identifier
    path: (scoped_identifier
      (identifier) @_regex
      (#any-of? @_regex "RegexSet" "RegexSetBuilder") .)
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (array_expression
      (raw_string_literal) @injection.content))
  (#set! injection.language "regex"))

((block_comment) @injection.content
  (#match? @injection.content "/\\*!([a-zA-Z]+:)?re2c")
  (#set! injection.language "re2c"))
