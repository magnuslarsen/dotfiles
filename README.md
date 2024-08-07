# My personal configs

This is mine, it probably doesn't fit your desires :-)

## Required packages

### Arch

on Arch, simply run:

```sh
yay -S bat chezmoi eza fd fish fzf git go gojq jaq jq kitty neovim nodejs npm python-pip python-pynvim riff ripgrep starship tmux tokei tokei ttf-fira-code yay yq
```

### Ubuntu

Canonical being a pain in the ass, you have to do this:

```sh
sudo add-apt-repository ppa:fish-shell/release-3
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:longsleep/golang-backports
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - # gotta love nodesource

sudo apt install fish fonts-firacode git golang-go gojq jq kitty neovim nodejs python3-pip ripgrep tmux
python3 -m pip install pynvim

# Install Python "binaries" in pipx
python3 -m pip install --user pipx
python3 -m pipx ensurepath

pipx install yq

# Build remaining packages that are not available on Ubuntu repos..
cargo install --locked bat eza fd-find hyperfine jaq riffdiff ripgrep starship tokei
go install github.com/junegunn/fzf@latest
```

## Chezmoi

Chezmoi is managing all of these configs, initialize it like so:

```sh
# assuming an ssh-key is setup
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply git@github.com:magnuslarsen/dotfiles.git

# or preinstalled:
chezmoi init --apply git@github.com:magnuslarsen/dotfiles.git
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
rm ~/.config/fish/functions/fzf_configure_bindings.fish && fisher update && chezmoi update --force
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
