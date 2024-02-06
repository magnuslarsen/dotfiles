; AWK stuff - does not work inline :'(
(command
  name: (command_name) @_cmd (#match? @_cmd "awk$")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "awk")
)

; jq - the best tool - does not work inline :'(
(command
  name: (command_name) @_cmd (#match? @_cmd "jq")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "jq")
)
