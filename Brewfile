# Everything these dotfiles need on a fresh Mac.
# Install with:  brew bundle --file Brewfile   (run by ./init.sh)

# --- Core shell, multiplexer, deploy ---
# (no git here: the Xcode Command Line Tools already provide git and the
#  compiler treesitter needs. A fresh Mac installs them the first time you run
#  `git`, which happens when you clone this repo, so they're there by init time.)
brew "bash"        # modern bash 5.x (login shell; macOS ships 3.2)
brew "tmux"        # multiplexer
brew "stow"        # symlink-farm manager used to deploy this repo

# --- Prompt & CLI niceties ---
brew "starship"    # prompt
brew "eza"         # better ls (aliased in .bashrc)
brew "jq"          # used by the Claude Code statusline

# --- Editor + its tooling ---
brew "neovim"
brew "ripgrep"     # telescope live-grep
brew "fd"          # telescope file-find
brew "node"        # Mason JS/TS LSPs
brew "python"      # python runtime (Mason tools, nvim provider)
brew "black"       # python formatter (conform on save)
brew "prettier"    # js/ts/json/md formatter (conform on save)

# --- GUI terminal + font ---
cask "alacritty"
cask "font-lilex-nerd-font"
