(expression_statement
  (call
    (attribute
      attribute: (identifier) @_attribute (#match? @_attribute "^(execute|executemany)$")
    )

    (argument_list
      (string
	(string_content) @sql
      )
    )
  )
)
