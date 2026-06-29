# Dotfiles

My dotfiles for macOS and Ubuntu/Athena. Everything lives in this repo as GNU
Stow packages, and [`init.sh`](init.sh) is the entrypoint I use on a fresh
machine. It checks the OS and then runs the right bootstrap script.

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

## Fresh Ubuntu / Athena

```bash
git clone https://github.com/jmuncor/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./init.sh
```

On Linux this runs `script/bootstrap ubuntu`. That script:

1. runs `sudo apt update`,
2. installs exactly the packages listed in
   [`apt-packages.ubuntu.txt`](apt-packages.ubuntu.txt),
3. installs Starship if it is not already there,
4. makes sure TPM exists at `~/.config/tmux/plugins/tpm`,
5. backs up a regular Ubuntu `~/.bashrc` to `~/.bashrc.before-dotfiles` if
   needed,
6. stows the packages listed in [`stow-packages.txt`](stow-packages.txt),
7. shows the backup path and asks whether to delete it.

The Ubuntu package list is just my baseline. It is not supposed to match the
Mac Brewfile one-for-one.

## Manual follow-up

After setup I still do these by hand:

1. Open a fresh shell.
2. Inside tmux, press <kbd>Ctrl-b</kbd> then <kbd>I</kbd> to install plugins.
3. Launch `nvim` once to bootstrap plugins.
4. Run `:checkhealth` in nvim.

## Stow layout

Each top-level folder is a Stow package that mirrors paths under `$HOME`:

| Package | Stows to | Purpose |
| --- | --- | --- |
| `alacritty/` | `~/.config/alacritty/alacritty.toml` | Terminal config |
| `bash/` | `~/.bashrc`, `~/.bash_profile` | Shell config |
| `claude/` | `~/.claude/settings.json`, `~/.claude/statusline.sh` | Claude Code config |
| `codex/` | `~/.codex/config.toml` | Codex config |
| `git/` | `~/.config/git/config` | Git config |
| `nvim/` | `~/.config/nvim/` | Neovim config |
| `starship/` | `~/.config/starship.toml` | Prompt config |
| `tmux/` | `~/.config/tmux/tmux.conf` | tmux config |

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

[`apt-packages.ubuntu.txt`](apt-packages.ubuntu.txt) is the Ubuntu package
list and gets applied with `apt`.

[`stow-packages.txt`](stow-packages.txt) is the shared config package list for
both platforms.

## Secrets

I do not commit secrets, tokens, auth files, local credentials, SSH keys,
private keys, or machine-specific private data. Local MCP server definitions and
anything else auth-related stays untracked.

## Clipboard (OSC 52)

Copying inside tmux reaches the system clipboard through OSC 52. `tmux.conf`
passes the escape sequence through (`set-clipboard on`, `allow-passthrough on`),
and Alacritty has `osc52 = "CopyPaste"` enabled. That is what makes copy work
when I SSH into a remote box from inside a Mac tmux pane.

## Neovim keybindings

| Key | Action |
| --- | --- |
| `<Space>` | Leader key |
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>w` | Save file |

## tmux keybindings

| Key | Action |
| --- | --- |
| `Ctrl-b` | Prefix |
| `Prefix + I` | Install plugins |
| `Prefix + %` | Split panes left/right |
| `Prefix + "` | Split panes top/bottom |
| `Alt-H` / `Alt-L` | Previous / next window |
| `Prefix + Ctrl-h/j/k/l` | Resize current pane |
