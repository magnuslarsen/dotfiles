# My personal configs
This is mine, it probably doesn't fit your desires :-)

# Required packages
on Arch, simply run:
```
yay -S bat exa fd fish fzf git git-delta go jq kitty neovim python-pip ripgrep tmux ttf-fira-code yay yq
```
On Ubuntu, good luck :-)

# Fish (fisherman)
Simply run:
```sh
fisher update && chezmoi update --force
```

# NerdFont
Some of this config, besides the original FiraCode, requires FireCode NerdFont to work properly, it can be fetched like so:
```sh
wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz" -O - | tar --wildcards -xJC ~/.local/share/fonts/ "*.ttf" && fc-cache && echo "Finished downloading FiraCode"
```

# PyLSP
For PyLSP, additional tools needs to be installed, which is not done by Mason:
```vim
:PylspInstall python-lsp-ruff python-lsp-black
```