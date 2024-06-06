; extends

; there's no jinja2 grammar, so we use twig instead since it's very similar
(block_mapping_pair
  value: [
    (block_node
      (block_scalar) @injection.content)
    (flow_node
      (double_quote_scalar) @injection.content)
  ]
  (#set! injection.language "twig")
  (#contains? @injection.content "{{"))

(block_mapping_pair
  value: [
    (block_node
      (block_scalar) @injection.content)
    (flow_node
      (double_quote_scalar) @injection.content)
  ]
  (#set! injection.language "twig")
  (#contains? @injection.content "{%"))

; Bash injections for Ansible's `command` & `shell` methods
; Unquoted strings
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")))
          value: (flow_node
            (plain_scalar
              (string_scalar) @injection.content
              (#set! injection.language "bash"))))))))

; Unquoted strings - for windows
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key
                "win_command" "win_shell" "ansible.windows.win_command" "ansible.windows.win_shell")))
          value: (flow_node
            (plain_scalar
              (string_scalar) @injection.content
              (#set! injection.language "powershell"))))))))

; Unquoted strings (with shell.cmd / command.cmd)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")))
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key
                    (#eq? @_sub_key "cmd")))
                value: (flow_node
                  (plain_scalar
                    (string_scalar) @injection.content
                    (#set! injection.language "bash")))))))))))

; Unquoted strings (with shell.cmd / command.cmd) - for windows
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key
                "win_command" "win_shell" "ansible.windows.win_command" "ansible.windows.win_shell")))
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key
                    (#eq? @_sub_key "cmd")))
                value: (flow_node
                  (plain_scalar
                    (string_scalar) @injection.content
                    (#set! injection.language "powershell")))))))))))

; Double- and single qouted strings
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")))
          value: (flow_node
            [
              (double_quote_scalar)
              (single_quote_scalar)
            ] @injection.content
            (#set! injection.language "bash")
            (#offset! @injection.content 0 1 0 -1)))))))

; Double- and single qouted strings - for windows
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key
                "win_command" "win_shell" "ansible.windows.win_command" "ansible.windows.win_shell")))
          value: (flow_node
            [
              (double_quote_scalar)
              (single_quote_scalar)
            ] @injection.content
            (#set! injection.language "powershell")
            (#offset! @injection.content 0 1 0 -1)))))))

; Double- and single qouted strings (with shell.cmd / command.cmd)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")))
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key
                    (#eq? @_sub_key "cmd")))
                value: (flow_node
                  [
                    (double_quote_scalar)
                    (single_quote_scalar)
                  ] @injection.content
                  (#set! injection.language "bash")
                  (#offset! @injection.content 0 1 0 -1))))))))))

; Double- and single qouted strings (with shell.cmd / command.cmd) - for windows
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key
                "win_command" "win_shell" "ansible.windows.win_command" "ansible.windows.win_shell")))
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key
                    (#eq? @_sub_key "cmd")))
                value: (flow_node
                  [
                    (double_quote_scalar)
                    (single_quote_scalar)
                  ] @injection.content
                  (#set! injection.language "powershell")
                  (#offset! @injection.content 0 1 0 -1))))))))))

; Support "|" and ">"
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")))
          value: (block_node
            (block_scalar) @injection.content
            (#set! injection.language "bash")
            (#offset! @injection.content 0 1 0 0)))))))

; Support "|" and ">" - for windows
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key
                "win_command" "win_shell" "ansible.windows.win_command" "ansible.windows.win_shell")))
          value: (block_node
            (block_scalar) @injection.content
            (#set! injection.language "powershell")
            (#offset! @injection.content 0 1 0 0)))))))

; Support "|" and ">" (with shell.cmd / command.cmd)
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key "command" "shell" "ansible.builtin.command" "ansible.builtin.shell")))
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key
                    (#eq? @_sub_key "cmd")))
                value: (block_node
                  (block_scalar) @injection.content
                  (#set! injection.language "bash")
                  (#offset! @injection.content 0 1 0 0))))))))))

; Support "|" and ">" (with shell.cmd / command.cmd) - for windows
(block_sequence
  (block_sequence_item
    (_
      (_
        (block_mapping_pair
          key: (flow_node
            (plain_scalar
              (string_scalar) @_key
              (#any-of? @_key
                "win_command" "win_shell" "ansible.windows.win_command" "ansible.windows.win_shell")))
          value: (block_node
            (block_mapping
              (block_mapping_pair
                key: (flow_node
                  (plain_scalar
                    (string_scalar) @_sub_key
                    (#eq? @_sub_key "cmd")))
                value: (block_node
                  (block_scalar) @injection.content
                  (#set! injection.language "powershell")
                  (#offset! @injection.content 0 1 0 0))))))))))
