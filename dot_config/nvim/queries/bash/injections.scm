; AWK stuff
(command
  name: (command_name) @_cmd (#eq? @_cmd "awk")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "awk")
)

; jq - the best tool
(command
  name: (command_name) @_cmd (#any-of? @_cmd "jq" "gojq")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "jq")
)

; sqlite3 - could extend to mysql/postgres?
(command
  name: (command_name) @_cmd (#eq? @_cmd "sqlite3")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql")
)

;; For some reason, `after/queries` does not include my custom parsers
;; so include upstream parsers - above is not stable enough for upstream (yet anyway)
;; ref: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/bash/injections.scm
((comment) @injection.content
  (#set! injection.language "comment"))

((regex) @injection.content
  (#set! injection.language "regex"))

((heredoc_redirect
  (heredoc_body) @injection.content
  (heredoc_end) @injection.language)
  (#downcase! @injection.language))

; printf 'format'
((command
  name: (command_name) @_command
  .
  argument: [
    (string
      (string_content) @injection.content)
    (concatenation
      (string
        (string_content) @injection.content))
    (raw_string) @injection.content
    (concatenation
      (raw_string) @injection.content)
  ])
  (#eq? @_command "printf")
  (#set! injection.language "printf"))

; printf -v var 'format'
((command
  name: (command_name) @_command
  argument: (word) @_arg
  .
  (_)
  .
  argument: [
    (string
      (string_content) @injection.content)
    (concatenation
      (string
        (string_content) @injection.content))
    (raw_string) @injection.content
    (concatenation
      (raw_string) @injection.content)
  ])
  (#eq? @_command "printf")
  (#eq? @_arg "-v")
  (#set! injection.language "printf"))

; printf -- 'format'
((command
  name: (command_name) @_command
  argument: (word) @_arg
  .
  argument: [
    (string
      (string_content) @injection.content)
    (concatenation
      (string
        (string_content) @injection.content))
    (raw_string) @injection.content
    (concatenation
      (raw_string) @injection.content)
  ])
  (#eq? @_command "printf")
  (#eq? @_arg "--")
  (#set! injection.language "printf"))
