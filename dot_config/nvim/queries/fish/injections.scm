; extends

; AWK stuff
(command
  name: (word) @_cmd
  (#eq? @_cmd "awk")
  argument: (single_quote_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "awk"))

; jq - the best tool
(command
  name: (word) @_cmd
  (#any-of? @_cmd "gojq" "jaq" "jq" "tomlq" "xq" "yq")
  argument: (single_quote_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "jq"))

; sqlite3
(command
  name: (word) @_cmd
  (#eq? @_cmd "sqlite3")
  argument: [
    (double_quote_string) @injection.content
    (single_quote_string) @injection.content
  ]
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

; Postgresql
(command
  name: (word) @_cmd
  (#eq? @_cmd "psql")
  argument: (word) @_arg
  (#eq? @_arg "-c")
  argument: [
    (double_quote_string) @injection.content
    (single_quote_string) @injection.content
  ]
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))
