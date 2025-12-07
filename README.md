# Dotfiles (Ghostty + Tmux + LazyVim)

My personal configuration files for macOS, featuring a high-performance setup with **Ghostty**, **Tmux**, and **LazyVim** (Neovim).

The visual style is unified around the **Tokyo Night** theme. This repository also addresses the "Green Bar" issue on macOS where Tmux themes fail to load due to outdated system Bash versions.

## Step 1: Initial setup

* **1. Install [Homebrew](https://brew.sh/)**
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

* **1. Install modern Bash**
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
## Step 2: Get the config files

Clone the repository:
```bash
git clone https://github.com/jmuncor/.dotfiles.git ~/.dotfiles
```

---
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

---
## Step 4: Source the config.zsh in the .zshrc file

```bash
echo 'source ~/.dotfiles/zsh/config.zsh' >> ~/.zshrc
source ~/.zshrc
```
