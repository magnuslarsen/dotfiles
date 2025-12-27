set -gx fish_greeting

# FZF stuff
function fzf_preview_dir_cmd_fun
    if command --query eza
        eza -lg --color=always --icons=always $argv
    else
        ls -l --color=always $argv
    end
end

set -U fzf_preview_file_cmd preview
set -U fzf_preview_dir_cmd fzf_preview_dir_cmd_fun
set fzf_history_time_format %d-%m-%y
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_diff_highlighter riff --no-pager --color on

# Bat stuff
if command --query bat
    alias cat="bat -p"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# And prefer nvim if it is here
if command --query nvim
    set -gx MANPAGER "nvim +Man!"
end

# Include (nvim) Mason installed binaries
fish_add_path ~/.local/share/nvim/mason/bin

if command --query starship
    starship init fish | source
end

# Setup ssh-agent and load keys as LAST step
set -gx GPG_TTY (tty)
fish_ssh_agent

if test -d ~/.password-store/ssh/ -a (ls -1q ~/.password-store/ssh/ | wc -l) -gt 0
    ssh-add-pass
end

# Restore "old" fish keybinds (emacs style)
bind alt-backspace backward-kill-word
bind ctrl-alt-h backward-kill-word
bind ctrl-backspace backward-kill-token
bind alt-delete kill-word
bind ctrl-delete kill-token
