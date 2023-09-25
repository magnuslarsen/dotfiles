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

