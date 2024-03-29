# My personal configs

This is mine, it probably doesn't fit your desires :-)

## Required packages

### Arch

on Arch, simply run:

```sh
yay -S bat difftastic eza fd fish fzf git go jq kitty neovim nodejs npm python-pip ripgrep starship tmux ttf-fira-code yay yq
```

### Ubuntu

Canonical being a pain in the ass, you have to do this:

```sh
sudo add-apt-repository ppa:fish-shell/release-3
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:longsleep/golang-backports
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - # Gotta love nodesource

sudo apt install fish fonts-firacode git golang-go jq kitty neovim nodejs python3-pip ripgrep tmux
python3 -m pip install pynvim yq
```

`bat`, `difftastic`, `eza`, `fd`, `fzf`, `starship`, `kitty` (newer version), and `ripgrep` (newer version) are packages you gotta download manually :-)

## Chezmoi

Chezmoi is managing all of these configs, initialize it like so:

```sh
chezmoi init --apply https://github.com/magnuslarsen/dotfiles.git
```

## Tmux

Tmux also has a couple of plugins that need to be installed:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# press CTRL+B I
```

## Fish (fisherman)

Simply run:

```sh
fisher update && chezmoi update --force
```

## NerdFont

Some of this config, besides the original FiraCode, requires FireCode NerdFont to work properly, it can be fetched like so:

```sh
mkdir -p ~/.local/share/fonts && \
wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz" -O - |\
tar --wildcards -xJC ~/.local/share/fonts/ "*.ttf" && \
fc-cache -f && echo "Finished downloading Nerd Font"
```

## PyLSP

For PyLSP, additional tools needs to be installed, which is not done by Mason:

```vim
:PylspInstall python-lsp-ruff ruff
```
