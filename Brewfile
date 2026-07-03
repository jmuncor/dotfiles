# Fresh Mac baseline for these dotfiles.
# ./init.sh runs this with: brew bundle --file Brewfile

# git and vim stay out: the Xcode Command Line Tools bring git, and macOS
# ships vim 9.
brew "bash"        # bash 5.x for my login shell; macOS ships 3.2
brew "tmux"        # multiplexer
brew "stow"        # symlinks the dotfile packages into $HOME
brew "starship"    # prompt
brew "jq"          # Claude Code statusline uses this

# Terminal font; the OneDark.terminal profile expects it.
cask "font-lilex-nerd-font"
