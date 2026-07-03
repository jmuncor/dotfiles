# Dotfiles

My dotfiles for macOS and RHEL. Everything lives in this repo as GNU Stow
packages, and [`init.sh`](init.sh) is the entrypoint I use on a fresh machine.
It checks the OS and then runs the right bootstrap script. The setup is
deliberately minimal: stock tools, no plugins beyond tmux, nothing that needs
extra repos.

## Fresh Mac

```bash
git clone https://github.com/jmuncor/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./init.sh
```

On macOS this ends up running `script/bootstrap macos`. That script:

1. installs Homebrew if it is missing,
2. runs `brew bundle` using [`Brewfile`](Brewfile),
3. makes sure TPM exists at `~/.config/tmux/plugins/tpm`,
4. stows the packages listed in [`stow-packages.txt`](stow-packages.txt),
5. switches the login shell to `/opt/homebrew/bin/bash` when it can.

## Fresh RHEL

```bash
git clone https://github.com/jmuncor/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./init.sh
```

On a RHEL-family box (`rhel`, `fedora`, or `centos` in `/etc/os-release`) this
runs `script/bootstrap rhel`. Anything else fails loudly instead of
half-installing. That script:

1. installs exactly the packages listed in
   [`dnf-packages.rhel.txt`](dnf-packages.rhel.txt) — base repos only, no
   EPEL,
2. installs Starship if it is not already there,
3. makes sure TPM exists at `~/.config/tmux/plugins/tpm`,
4. backs up the stock `~/.bashrc` and `~/.bash_profile` to
   `*.before-dotfiles` if needed,
5. stows the packages listed in [`stow-packages.txt`](stow-packages.txt),
6. shows the backup paths and asks whether to delete them.

The RHEL package list is just my baseline. It is not supposed to match the
Mac Brewfile one-for-one.

## Manual follow-up

After setup I still do these by hand:

1. Open a fresh shell.
2. Inside tmux, press <kbd>Ctrl-b</kbd> then <kbd>I</kbd> to install plugins.
3. On the Mac: `open terminal/OneDark.terminal`, then set the "OneDark"
   profile as default in Terminal → Settings → Profiles.

## Stow layout

Each top-level folder is a Stow package that mirrors paths under `$HOME`:

| Package | Stows to | Purpose |
| --- | --- | --- |
| `bash/` | `~/.bashrc`, `~/.bash_profile` | Shell config |
| `claude/` | `~/.claude/settings.json`, `~/.claude/statusline.sh` | Claude Code config |
| `git/` | `~/.config/git/config` | Git config |
| `starship/` | `~/.config/starship.toml` | Prompt config |
| `tmux/` | `~/.config/tmux/tmux.conf` | tmux config |
| `vim/` | `~/.vimrc` | Vim config |

`script/stow` reads [`stow-packages.txt`](stow-packages.txt) and targets
`$HOME`. By default it is cautious: it runs a dry run first, prints any
conflicts, and exits before changing anything.

If I want Stow to adopt existing files into the repo, I have to run it on
purpose:

```bash
script/stow --adopt
```

`--adopt` can move existing target files into this repo before `git restore`
puts the package contents back to the committed version, so I keep it opt-in.

## Package lists

[`Brewfile`](Brewfile) is the Mac package list and gets applied with
`brew bundle`.

[`dnf-packages.rhel.txt`](dnf-packages.rhel.txt) is the RHEL package list and
gets applied with `dnf`.

[`stow-packages.txt`](stow-packages.txt) is the shared config package list for
both platforms.

## Terminal theme

Configs only name the 16 ANSI color slots. What the slots look like — the One
Dark palette and the Lilex Nerd Font — lives in
[`terminal/OneDark.terminal`](terminal/OneDark.terminal), imported into
Terminal.app by hand (follow-up step 3). Not a Stow package; Terminal copies
it into its own settings.

The RHEL box needs no theme files: the local terminal renders colors and
fonts, so the stowed configs there pick up One Dark whenever I connect from
the Mac.

Slot mapping: bright black is the One Dark grey, bright yellow the orange.

## Secrets

I do not commit secrets, tokens, auth files, local credentials, SSH keys,
private keys, or machine-specific private data. Local MCP server definitions and
anything else auth-related stays untracked.

## Clipboard (OSC 52)

`tmux.conf` passes OSC 52 through (`set-clipboard on`, `allow-passthrough on`),
but Terminal.app does not support OSC 52, so remote-to-local copy does not
work. Local copy goes through tmux-yank and `pbcopy`. If I ever need the
remote path, I need an OSC 52 capable terminal (iTerm2, kitty).

## Vim keybindings

Plugin-free `.vimrc` so the same muscle memory works on any box.

| Key | Action |
| --- | --- |
| `<Space>` | Leader key |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<Esc><Esc>` | Clear search highlight |
| `Ctrl-h/j/k/l` | Move between windows |
| `<` / `>` (visual) | Indent and keep selection |
| `J` / `K` (visual) | Move selected lines |

## tmux keybindings

| Key | Action |
| --- | --- |
| `Ctrl-b` | Prefix |
| `Prefix + I` | Install plugins |
| `Prefix + %` | Split panes left/right |
| `Prefix + "` | Split panes top/bottom |
| `Alt-H` / `Alt-L` | Previous / next window |
| `Prefix + Ctrl-h/j/k/l` | Resize current pane |
