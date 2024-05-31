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

; From upstream
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/yaml/injections.scm
((comment) @injection.content
  (#set! injection.language "comment"))

; Github actions ("run") / Gitlab CI ("scripts")
(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "bash")))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "bash")))))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "script" "before_script" "after_script")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 0))))))

; Prometheus Alertmanager ("expr")
(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "promql")))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "promql")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "promql")))))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "promql")
          (#offset! @injection.content 0 1 0 0))))))
