# My personal configs
This is mine, it probably doesn't fit your desires :-)

# Required packages
## Arch
on Arch, simply run:
```sh
yay -S bat exa fd fish fzf git git-delta go jq kitty neovim nodejs npm python-pip ripgrep tmux ttf-fira-code yay yq
```

## Ubuntu
Canonical being a pain in the ass, you have to do this:
```sh
sudo add-apt-repository ppa:fish-shell/release-3
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:longsleep/golang-backports
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - # Gotta love nodesource

sudo apt install fish fonts-firacode git golang-go jq kitty neovim nodejs npm python3-pip ripgrep tmux
python3 -m pip install pynvim yq
```
`bat`, `exa`, `fd`, `fzf`, `git-delta`, `kitty` (newer version), and `ripgrep` (newer version) are packages you gotta download manually :-)

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
