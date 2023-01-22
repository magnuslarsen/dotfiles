set -gx GPG_TTY (tty)
fish_ssh_agent

set -U fzf_preview_file_cmd preview
set -U fzf_preview_dir_cmd exa -lg --color=always
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
