# Juancho's bash setup.
# My main machine runs Homebrew bash on macOS, but this also works on Linux as
# long as the same tools are installed.

# Only do this for interactive shells.
case $- in
  *i*) ;;
  *) return ;;
esac

# PATH.
# Put Homebrew and user-local bins first, without duplicating entries.
for dir in /opt/homebrew/bin "$HOME/.local/bin"; do
  case ":$PATH:" in
    *":$dir:"*) ;;
    *) [ -d "$dir" ] && export PATH="$dir:$PATH" ;;
  esac
done

# Neovim is my default editor.
export EDITOR='nvim'
export VISUAL='nvim'

# Silence macOS's "default shell is now zsh" nag for bash.
export BASH_SILENCE_DEPRECATION_WARNING=1

# History.
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth          # skip duplicates and leading-space commands
shopt -s histappend             # append instead of overwriting
shopt -s checkwinsize           # keep $LINES/$COLUMNS current

# Completion.
# Prefer Homebrew completion, then the normal Linux path.
if ! shopt -oq posix; then
  if [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  fi
fi

# Prompt.
# Starship reads the stowed config from ~/.config/starship.toml.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# Aliases.
# eza replaces ls when it is installed.
if command -v eza >/dev/null 2>&1; then
  # Flat lists.
  alias l="eza --icons --oneline"
  alias ls="eza --icons --oneline"
  alias ll="eza -lg --icons --oneline"
  alias la="eza -lag --icons --oneline"

  # Tree views.
  alias lt="eza -lTg --icons"
  alias lt1="eza -lTg --level=1 --icons"
  alias lt2="eza -lTg --level=2 --icons"
  alias lt3="eza -lTg --level=3 --icons"

  # Tree views with hidden files.
  alias lta="eza -lTag --icons"
  alias lta1="eza -lTag --level=1 --icons"
  alias lta2="eza -lTag --level=2 --icons"
  alias lta3="eza -lTag --level=3 --icons"
else
  # Plain ls fallback.
  alias ls="ls --color=auto"
  alias ll="ls -lh --color=auto"
  alias la="ls -lAh --color=auto"
fi

# Keep grep readable.
alias grep="grep --color=auto"

# Auto-start tmux unless I am already inside it.
if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
  tmux attach-session 2>/dev/null || tmux new-session -s juancho
fi
