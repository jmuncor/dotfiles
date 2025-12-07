# Dotfiles (Ghostty + Tmux + LazyVim)

My personal configuration files for macOS, featuring a high-performance setup with **Ghostty**, **Tmux**, and **LazyVim** (Neovim).

The visual style is unified around the **Tokyo Night** theme. This repository also addresses the "Green Bar" issue on macOS where Tmux themes fail to load due to outdated system Bash versions.

## Step 1: Initial setup

* **1. Install [Homebrew](https://brew.sh/)**
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

* **2. Install [Ghostty](https://ghostty.org/)**
  ```bash
  brew install --cask ghostty

* **3. Install modern Bash, Nvim, Tmux and Zsh goddies to make it look nicer**
  ```bash
  brew install bash tmux neovim starship eza zsh-autosuggestions zsh-syntax-highlighting

* **4. Install [LazyVim](https://www.lazyvim.org/)**
  ```bash
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

## Step 2: Get the config files

Clone the repository:
```bash
git clone https://github.com/jmuncor/.dotfiles.git ~/.dotfiles
```

## Step 3: System linking the Ghostty and Tmux config files

Link the default config files to the dotfiles folder

```bash
# 1. Ghostty
mkdir -p ~/.config/ghostty
rm ~/.config/ghostty/config
ln -s ~/.dotfiles/ghostty/config ~/.config/ghostty/config

# 2. Tmux
mkdir -p ~/.config/tmux
rm ~/.tmux.conf
rm ~/.config/tmux/tmux.conf
ln -s ~/.dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

## Step 4: Source the config.zsh in the .zshrc file

```bash
echo 'source ~/.dotfiles/zsh/config.zsh' >> ~/.zshrc
source ~/.zshrc
```

## Step 5: Enable LazyVim extras

The config for LazyVim is pretty much the default one, just add some extras to add AI capabilities and goodies.
Type `:LazyExtras`, navigate to the plugin you want, and press <kbd>x</kbd> to enable it.

* [x] **ai.copilot** (GitHub Copilot)
* [x] **ai.avante** (AI coding assistant)
* [x] **util.mini-hipatterns** (Highlighting utilities)
