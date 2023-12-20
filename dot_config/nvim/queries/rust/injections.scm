; SQL highlighting for SQLX
(call_expression
  (scoped_identifier
      path: (identifier) @_path (#eq? @_path "sqlx")
      name: (identifier) @_name (#any-of? @_name "query" "query_as")
    )

    (arguments
      (raw_string_literal) @injection.content
      (#offset! @injection.content 0 3 0 -3)
      (#set! injection.language "sql")
    )
)
(call_expression
  (scoped_identifier
      path: (identifier) @_path (#eq? @_path "sqlx")
      name: (identifier) @_name (#any-of? @_name "query" "query_as")
    )

    (arguments
      (string_literal) @injection.content
      (#offset! @injection.content 0 1 0 -1)
      (#set! injection.language "sql")
    )
)
(macro_invocation
  (scoped_identifier
      path: (identifier) @_path (#eq? @_path "sqlx")
      name: (identifier) @_name (#any-of? @_name "query" "query_as")
    )

    (token_tree
      (string_literal) @injection.content
      (#offset! @injection.content 0 1 0 -1)
      (#set! injection.language "sql")
    )
)
(macro_invocation
  (scoped_identifier
      path: (identifier) @_path (#eq? @_path "sqlx")
      name: (identifier) @_name (#any-of? @_name "query" "query_as")
    )

    (token_tree
      (raw_string_literal) @injection.content
      (#offset! @injection.content 0 3 0 -3)
      (#set! injection.language "sql")
    )
)
