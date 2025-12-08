# ==============================================
#  Juancho's Zsh Configuration
# ==============================================

# --- 1. Path & Compatibility Fixes ---
# Fix for Tmux "Green Bar" (Ensure we see Homebrew Bash v5+)
export PATH="/opt/homebrew/bin:$PATH"

# Default Editor (Neovim)
export EDITOR='nvim'

# --- 2. Starship Prompt (Visuals) ---
export STARSHIP_CONFIG=~/.dotfiles/zsh/starship.toml
eval "$(starship init zsh)"

# --- 3. Aliases (Shortcuts) ---

# Eza (Better 'ls')
# --icons: Shows file type icons
# --git: Shows git status (dirty, ignored)
# --group-directories-first: Keeps folders at the top

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

# --- 4. Zsh Plugins (Homebrew) ---
# Autosuggestions (Grey ghost text)
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax Highlighting (Green/Red commands) - MUST BE LAST
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- Auto-Start Tmux in Ghostty ---
# Checks if:
# 1. We are running inside Ghostty (TERM_PROGRAM)
# 2. We are NOT already inside a Tmux session (TMUX)
if [[ "$TERM_PROGRAM" == "ghostty" ]] && [[ -z "$TMUX" ]]; then
    # Try to attach to a session named "main", or create it if missing
    tmux attach-session -t main || tmux new-session -s main
fi
