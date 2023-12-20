; SQL highlighting for SQLX
; TODO: string_literals, and query_as(!) functions
(call_expression
  (scoped_identifier
      path: (identifier) @_path (#eq? @_path "sqlx")
      name: (identifier) @_name (#any-of? @_name "query" "query!")
    )

    (arguments
      (raw_string_literal) @injection.content
      (#offset! @injection.content 0 3 0 -3)
      (#set! injection.language "sql")
    )
)

