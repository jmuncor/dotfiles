# Dotfiles (Ghostty + Tmux + LazyVim)

My personal configuration files for macOS, featuring a high-performance setup with **Ghostty**, **Tmux**, and **LazyVim** (Neovim).

The visual style is unified around the **Tokyo Night** theme. This repository also addresses the "Green Bar" issue on macOS where Tmux themes fail to load due to outdated system Bash versions.

## Step 1: Initial setup

* **1. Install [Homebrew](https://brew.sh/)**
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

* **1. Install modern bash**
  ```bash
  brew install bash
  
* **2. Install [Ghostty](https://ghostty.org/)**
  ```bash
  brew install --cask ghostty

* **3. Install [Tmux](https://github.com/tmux/tmux/wiki)**
  ```bash
  brew install tmux

* **4. Install [Neovim](https://neovim.io/)**
  ```bash
  brew install neovim

* **5. Install [LazyVim](https://www.lazyvim.org/)**
  ```bash
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

---

## Step 2: Fix the theme crashing

MacOS ships with **Bash v3.2** (from 2007) by default. The `tmux-tokyo-night` plugin requires **Bash 4.0+**. Without this fix, the theme crashes.

```bash
# 1. Install modern Bash
brew install bash

# 2. Add Homebrew binary path to your shell config
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc

# 3. Reload settings
source ~/.zshrc
```

---

## Step 3: System linking the config files

Link the default config files to the dotfiles folder

```bash

# 1. Ghostty
mkdir -p ~/.config/ghostty
rm ~/.config/ghostty/config
ln -s ~/.dotfiles/ghostty/config ~/.config/ghostty/config

# 1. Tmux
mkdir -p ~/.config/tmux
rm ~/.tmux.conf
rm ~/.config/tmux/tmux.conf
ln -s ~/.dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf

```
