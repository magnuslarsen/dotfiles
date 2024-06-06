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
  (#any-of? @_cmd "jq" "gojq")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "jq"))

; sqlite3 - could extend to mysql/postgres?
(command
  name: (command_name) @_cmd
  (#eq? @_cmd "sqlite3")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

