# Dotfiles (Ghostty + Tmux + LazyVim)

My personal configuration files for macOS, featuring a high-performance setup with **Ghostty**, **Tmux**, and **LazyVim** (Neovim).

The visual style is unified around the **Tokyo Night** theme. This repository also addresses the "Green Bar" issue on macOS where Tmux themes fail to load due to outdated system Bash versions.

## 🛠 Initial setup

* **1. Install [Homebrew](https://brew.sh/)**
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
* **2. Install [Ghostty](https://ghostty.org/)**
  ```bash
  brew install --cask ghostty

* **3. Install [Tmux](https://github.com/tmux/tmux/wiki)**
  ```bash
  brew install tmux

* **4. Install [LazyVim](https://www.lazyvim.org/)**
  
* **Ghostty:** [Download Ghostty](https://mitchellh.com/ghostty)

* **Tmux:** `brew install tmux`
* **Neovim (v0.9+):** `brew install neovim`
* **Bash (v4+):** `brew install bash`
* **Nerd Font:** (Ghostty includes one, but `JetBrains Mono Nerd Font` is recommended).

---

## ⚠️ Step 1: Fix the "Green Bar" (One-Time Setup)

macOS ships with **Bash v3.2** (from 2007) by default. The `tmux-tokyo-night` plugin requires **Bash 4.0+**. Without this fix, the theme crashes and displays a default green status bar.

Run these commands in your terminal:

```bash
# 1. Install modern Bash
brew install bash

# 2. Add Homebrew binary path to your shell config
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc

# 3. Reload settings
source ~/.zshrc
