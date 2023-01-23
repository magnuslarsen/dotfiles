set -gx GPG_TTY (tty)
fish_ssh_agent

set -U fzf_preview_file_cmd preview
set -U fzf_preview_dir_cmd fzf_preview_dir_cmd_fun
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

function fzf_preview_dir_cmd_fun
	if command --query exa
		exa -lg --color=always $argv
	else
		ls -l --color=always $argv
	end
end
