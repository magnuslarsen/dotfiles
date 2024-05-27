; Bash injections for Ansible's `command` & `shell` methods
; it should be possible to concat these "value"-fields no? [] did not work :'(

; Unquoted strings
(_
  (_
    (block_mapping_pair .
      key: (flow_node
        (plain_scalar
          (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
        )
      )
      value: (flow_node
        (plain_scalar
          (string_scalar) @injection.content
          (#set! injection.language "bash")
        )
      )
    ) .
  )
)

; Double- and single qouted strings
(_
  (_
    (block_mapping_pair .
      key: (flow_node
        (plain_scalar
          (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
        )
      )
      value: (flow_node
        (double_quote_scalar) @injection.content
        (#set! injection.language "bash")
        (#offset! @injection.content 0 1 0 -1)
      )
    ) .
  )
)
(_
  (_
    (block_mapping_pair .
      key: (flow_node
        (plain_scalar
          (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
        )
      )
      value: (flow_node
        (single_quote_scalar) @injection.content
        (#set! injection.language "bash")
        (#offset! @injection.content 0 1 0 -1)
      )
    ) .
  )
)

; Support "|" and ">" -- note; hackishly works with ">-" and "|-"
(_
  (_
    (block_mapping_pair .
      key: (flow_node
        (plain_scalar
          (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
        )
      )
      value: (block_node
        (block_scalar) @injection.content
        (#set! injection.language "bash")
        (#offset! @injection.content 0 1 0 0)
      )
    ) .
  )
)
