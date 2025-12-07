# Dotfiles (Ghostty + Tmux + LazyVim)

My personal configuration files for macOS, featuring a high-performance setup with **Ghostty**, **Tmux**, and **LazyVim** (Neovim).

The visual style is unified around the **Tokyo Night** theme. This repository also addresses the "Green Bar" issue on macOS where Tmux themes fail to load due to outdated system Bash versions.

## 🛠 Prerequisites

* **Ghostty:** [Download Ghostty](https://mitchellh.com/ghostty)
* **Homebrew:** The missing package manager for macOS.
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
