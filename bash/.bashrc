# Juancho's bash setup.

# PATH.
# Put Homebrew and user-local bins first, without duplicating entries.
path_prepend() {
  local dir="$1"

  [ -d "$dir" ] || return

  PATH=$(printf '%s' "$PATH" \
    | awk -v RS=: -v ORS=: -v d="$dir" '$0 != d' \
    | sed 's/:$//')

  PATH="$dir:$PATH"
}

path_prepend /opt/homebrew/bin
path_prepend "$HOME/.local/bin"

# Added by the simetrik installer; rewritten to use path_prepend so it stays
# machine-independent and stops re-adding itself on every shell.
path_prepend "$HOME/.simetrik/bin"

export PATH

# Vim as the default editor.
export EDITOR='vim'
export VISUAL='vim'

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
# --color works on GNU ls and on macOS since Ventura.
alias ls="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lAh --color=auto"

# Keep grep readable.
alias grep="grep --color=auto"

# Auto-start herdr unless I am already inside it.
# herdr sets HERDR_ENV=1 in the shells it spawns; without that guard every new
# pane would launch another herdr inside itself. $PS1 keeps this out of
# non-interactive login shells (scp, rsync, ssh <cmd>).
if [ -n "${PS1:-}" ] && [ "${HERDR_ENV:-}" != "1" ] && command -v herdr >/dev/null 2>&1; then
  herdr
fi
