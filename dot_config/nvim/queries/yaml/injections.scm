; Bash injections for Ansible's `command` & `shell` methods
; it should be possible to concat these "value"-fields no? [] did not work :'(

; Unquoted strings
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
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
        )
      )
    )
  )
)

; Unquoted strings (with shell.cmd / command.cmd)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
            )
          )
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key (#eq? @_sub_key "cmd")
                  )
                )
                value: (flow_node
                  (plain_scalar
                    (string_scalar) @injection.content
                    (#set! injection.language "bash")
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)


; Double- and single qouted strings
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
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
        )
      )
    )
  )
)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
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
        )
      )
    )
  )
)

; Double- and single qouted strings (with shell.cmd / command.cmd)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
            )
          )
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key (#eq? @_sub_key "cmd")
                  )
                )
                value: (flow_node
                  (double_quote_scalar) @injection.content
                  (#set! injection.language "bash")
                  (#offset! @injection.content 0 1 0 -1)
                )
              )
            )
          )
        )
      )
    )
  )
)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
            )
          )
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key (#eq? @_sub_key "cmd")
                  )
                )
                value: (flow_node
                  (single_quote_scalar) @injection.content
                  (#set! injection.language "bash")
                  (#offset! @injection.content 0 1 0 -1)
                )
              )
            )
          )
        )
      )
    )
  )
)

; Support "|" and ">" -- note; hackishly works with ">-" and "|-"
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
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
        )
      )
    )
  )
)

; Support "|" and ">" -- note; hackishly works with ">-" and "|-" (with shell.cmd / command.cmd)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")
            )
          )
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key (#eq? @_sub_key "cmd")
                  )
                )
                value: (block_node
                  (block_scalar) @injection.content
                  (#set! injection.language "bash")
                  (#offset! @injection.content 0 1 0 0)
                )
              )
            )
          )
        )
      )
    )
  )
)
