# ==============================================
#  Juancho's Bash Configuration (macOS, Homebrew bash)
# ==============================================
# Main machine is a Mac running Homebrew's bash 5.x as the login shell.
# Every external tool is wrapped in a `command -v` check so this file also
# works as-is on a Linux box that has the same tools.

# Only run for interactive shells.
case $- in
  *i*) ;;
  *) return ;;
esac

# --- 1. Path ---
# Homebrew bin (Apple Silicon) + user-local binaries. Prepend without adding
# duplicates when the file gets re-sourced.
for dir in /opt/homebrew/bin "$HOME/.local/bin"; do
  case ":$PATH:" in
    *":$dir:"*) ;;
    *) [ -d "$dir" ] && export PATH="$dir:$PATH" ;;
  esac
done

# Default editor (Neovim)
export EDITOR='nvim'
export VISUAL='nvim'

# Silence macOS's "default shell is now zsh" nag for bash.
export BASH_SILENCE_DEPRECATION_WARNING=1

# --- 2. History ---
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth          # no duplicates, no leading-space commands
shopt -s histappend             # append rather than overwrite
shopt -s checkwinsize           # keep $LINES/$COLUMNS up to date

# --- 3. Completion ---
# Homebrew's bash-completion first; fall back to a Linux system path.
if ! shopt -oq posix; then
  if [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  fi
fi

# --- 4. Starship Prompt (Visuals) ---
# Config lives at the default ~/.config/starship.toml (stowed).
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# --- 5. Aliases (Shortcuts) ---
# Eza (Better 'ls')
#   --icons: file type icons   --git: git status   --group-directories-first
if command -v eza >/dev/null 2>&1; then
  # Standard Lists
  alias l="eza --icons --oneline"
  alias ls="eza --icons --oneline"
  alias ll="eza -lg --icons --oneline"
  alias la="eza -lag --icons --oneline"

  # Tree Views (Hierarchy)
  alias lt="eza -lTg --icons"
  alias lt1="eza -lTg --level=1 --icons"
  alias lt2="eza -lTg --level=2 --icons"
  alias lt3="eza -lTg --level=3 --icons"

  # Tree Views + Hidden Files (All)
  alias lta="eza -lTag --icons"
  alias lta1="eza -lTag --level=1 --icons"
  alias lta2="eza -lTag --level=2 --icons"
  alias lta3="eza -lTag --level=3 --icons"
else
  # coreutils fallback if eza isn't installed.
  alias ls="ls --color=auto"
  alias ll="ls -lh --color=auto"
  alias la="ls -lAh --color=auto"
fi

# Colourful grep
alias grep="grep --color=auto"

# --- 6. Auto-start tmux ---
# On an interactive shell that isn't already inside tmux, attach to the most
# recent session (or create "juancho" if there are none) so every Alacritty
# window lands in a persistent tmux session.
if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
  tmux attach-session 2>/dev/null || tmux new-session -s juancho
fi
