; Doc-strings are RST
(function_definition
  (block
    (expression_statement
      (string
          (string_content) @injection.content 
          (#set! injection.language "rst")
      )
    )
  )
)

; Function calls from common SQL libraries
(expression_statement
  (call
    (attribute
      attribute: (identifier) @_attribute (#any-of? @_attribute "execute" "executemany" "executescript")
    )

    (argument_list
      (string
        (string_content) @injection.content
        (#set! injection.language "sql")
      )
    )
  )
)

; Variables ending in "_sql" and "_SQL"
(expression_statement
  (assignment
    left: (identifier) @_left (#match? @_left "(_sql|_SQL)$")
    right: (string
      (string_content) @injection.content
      (#set! injection.language "sql")
    )
  )
)

; Variables ending in "_json" and "_JSON"
(expression_statement
  (assignment
    left: (identifier) @_left (#match? @_left "(_json|_JSON)$")
    right: (string
      (string_content) @injection.content
      (#set! injection.language "json")
    )
  )
)
