# Fresh Mac baseline for these dotfiles.
# ./init.sh runs this with: brew bundle --file Brewfile

# git and vim stay out: the Xcode Command Line Tools bring git, and macOS
# ships vim 9.
brew "bash"        # bash 5.x for my login shell; macOS ships 3.2
brew "herdr"       # agent multiplexer; macOS only, see README
brew "stow"        # symlinks the dotfile packages into $HOME
brew "starship"    # prompt
brew "jq"          # Claude Code statusline uses this
brew "gh"          # GitHub CLI; needs `gh auth login` after setup
brew "btop"        # resource monitor
brew "node"        # JavaScript runtime
brew "pnpm"        # Node package manager
brew "wireshark"   # tshark and friends; CLI only, no GUI

# Homelab access. This is the menu bar client with its own system extension;
# sign in from the menu bar after setup. The `tailscale` formula is the
# daemon-only alternative and conflicts with the app, so it is one or the other.
cask "tailscale-app"

# Terminal font; the OneDark.terminal profile expects it.
cask "font-lilex-nerd-font"

# Claude desktop app and the Claude Code CLI.
cask "claude"
cask "claude-code"

# Desktop apps.
cask "1password"
cask "google-chrome"
cask "slack"
cask "whatsapp"
cask "zed"
cask "obs"
cask "spokenly"
cask "microsoft-word"
cask "microsoft-excel"
cask "microsoft-powerpoint"

# Menu bar utilities.
cask "aldente"     # battery charge limit
cask "stats"       # system monitor
