# Fresh Mac baseline for these dotfiles.
# ./init.sh runs this with: brew bundle --file Brewfile

# Shell, tmux, and deploy bits.
# I leave git out because the Xcode Command Line Tools already bring git and
# the compiler pieces treesitter needs. Cloning this repo is enough to trigger
# that install on a fresh Mac.
brew "bash"        # bash 5.x for my login shell; macOS ships 3.2
brew "tmux"        # multiplexer
brew "stow"        # symlinks the dotfile packages into $HOME

# Prompt and CLI extras.
brew "starship"    # prompt
brew "eza"         # better ls, aliased in .bashrc
brew "jq"          # Claude Code statusline uses this

# Editor and the tools Neovim expects.
brew "neovim"
brew "ripgrep"     # Telescope live grep
brew "fd"          # Telescope file finder
brew "node"        # Mason JS/TS LSPs
brew "python"      # Python runtime, Mason tools, nvim provider
brew "black"       # Python formatter through conform
brew "prettier"    # JS/TS/JSON/Markdown formatter through conform

# Terminal and font.
cask "alacritty"
cask "font-lilex-nerd-font"
