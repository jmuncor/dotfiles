#!/usr/bin/env bash
# Set up these dotfiles on a fresh Mac.
# Safe to re-run. Installs the tools, deploys the configs, and prints the
# couple of steps that change live state (login shell, plugin installs).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

PACKAGES=(alacritty bash claude git nvim starship tmux)
BREW_BASH="/opt/homebrew/bin/bash"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# --- 1. Homebrew --------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  log "Homebrew present ($(brew --version | head -1))"
fi

# --- 2. Tools from the Brewfile ----------------------------------------------
log "Installing tools (brew bundle)"
brew bundle --file "$REPO_DIR/Brewfile"

# --- 3. TPM (tmux plugin manager) --------------------------------------------
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
  log "TPM already present"
else
  log "Cloning TPM"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# --- 4. Deploy with stow -----------------------------------------------------
# Only stow packages that aren't already linked, so re-running does nothing on a
# machine that's already set up. A package is "done" when a stow dry run has no
# work left (it still prints a "simulation mode" notice, so ignore that one line).
# For the rest, --adopt pulls any pre-existing real file into the repo and links
# it back, then `git restore` resets it to the committed version so the link
# points at this repo's content.
# Stow targets the repo's parent by default and this repo lives under ~/Projects,
# so point it at $HOME or the links land in the wrong place.
needs_stow() {
  # -nv: dry run, verbose so a clean link prints "LINK:" (not just conflicts).
  # Already-stowed packages print only the "simulation mode" notice, which we drop.
  local out
  out=$(stow -nv --target="$HOME" "$1" 2>&1) || true
  [ -n "$(printf '%s\n' "$out" | grep -vF 'simulation mode')" ]
}

to_stow=()
for pkg in "${PACKAGES[@]}"; do
  needs_stow "$pkg" && to_stow+=("$pkg")
done

if [ ${#to_stow[@]} -eq 0 ]; then
  log "All packages already stowed"
else
  log "Stowing: ${to_stow[*]}"
  stow --adopt -v --target="$HOME" "${to_stow[@]}"
  git restore "${to_stow[@]}"
fi

# --- 5. Login shell ----------------------------------------------------------
if [ -x "$BREW_BASH" ]; then
  if ! grep -qxF "$BREW_BASH" /etc/shells 2>/dev/null; then
    log "Adding $BREW_BASH to /etc/shells (needs sudo)"
    echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
  fi
  if [ "${SHELL:-}" != "$BREW_BASH" ]; then
    log "Setting login shell to $BREW_BASH"
    chsh -s "$BREW_BASH" || log "chsh failed, run: chsh -s $BREW_BASH"
  fi
fi

# --- 6. Done -----------------------------------------------------------------
cat <<'EOF'

Done. Two things left to do by hand:

  1. Open a new terminal (tmux auto-attaches), then press Ctrl+b I
     to install the tmux plugins via TPM.
  2. Launch `nvim` once so it bootstraps lazy.nvim and the Mason LSPs.
     Run :checkhealth to verify.
EOF
