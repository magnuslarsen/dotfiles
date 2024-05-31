; Doc-strings are RST
(function_definition
  (block
    (expression_statement
      (string
        (string_content) @injection.content
        (#set! injection.language "rst")))))

; Function calls from common SQL libraries
(expression_statement
  (call
    (attribute
      attribute: (identifier) @_attribute
      (#any-of? @_attribute "execute" "executemany" "executescript"))
    (argument_list
      (string
        (string_content) @injection.content
        (#set! injection.language "sql")))))

; Variables ending in "_sql" and "_SQL"
(expression_statement
  (assignment
    left: (identifier) @_left
    (#match? @_left "(_sql|_SQL)$")
    right: (string
      (string_content) @injection.content
      (#set! injection.language "sql"))))

; Variables ending in "_json" and "_JSON"
(expression_statement
  (assignment
    left: (identifier) @_left
    (#match? @_left "(_json|_JSON)$")
    right: (string
      (string_content) @injection.content
      (#set! injection.language "json"))))

; From upstream
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/python/injections.scm
(call
  function: (attribute
    object: (identifier) @_re)
  arguments: (argument_list
    .
    (string
      (string_content) @injection.content))
  (#eq? @_re "re")
  (#set! injection.language "regex"))

((binary_operator
  left: (string
    (string_content) @injection.content)
  operator: "%")
  (#set! injection.language "printf"))

((comment) @injection.content
  (#set! injection.language "comment"))
