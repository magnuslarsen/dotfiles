; extends

; AWK stuff
(command
  name: (command_name) @_cmd
  (#eq? @_cmd "awk")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "awk"))

; jq - the best tool
(command
  name: (command_name) @_cmd
  (#any-of? @_cmd "gojq" "jaq" "jq" "tomlq" "xq" "yq")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "jq"))

; sqlite3
(command
  name: (command_name) @_cmd
  (#eq? @_cmd "sqlite3")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

; Postgresql
(command
  name: (command_name) @_cmd
  (#eq? @_cmd "psql")
  argument: (word) @_arg
  (#eq? @_arg "-c")
  argument: (string
    (string_content) @injection.content)
  (#set! injection.language "sql"))

(command
  name: (command_name) @_cmd
  (#eq? @_cmd "psql")
  argument: (word) @_arg
  (#eq? @_arg "-c")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))
