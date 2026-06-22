# Dotfiles

My personal setup for a **Mac** (my main machine), built around **Alacritty**,
**bash**, **tmux**, **Neovim**, and a **Starship** prompt, all themed with **One
Dark**. The configs are portable so they also work on a Linux box that has the
same tools installed.

## What's in here

Each top-level folder is a [GNU Stow](https://www.gnu.org/software/stow/)
package whose internal tree mirrors `$HOME`:

| Package     | Stows to                                              | What it is                              |
|-------------|------------------------------------------------------|-----------------------------------------|
| `alacritty/`| `~/.config/alacritty/alacritty.toml`                 | Terminal: font, colors, keybindings     |
| `bash/`     | `~/.bashrc`, `~/.bash_profile`                        | Shell: PATH, aliases, prompt, tmux      |
| `tmux/`     | `~/.config/tmux/tmux.conf`                            | Multiplexer + OSC 52 clipboard          |
| `nvim/`     | `~/.config/nvim/`                                     | Neovim (lazy.nvim + Mason LSPs)         |
| `starship/` | `~/.config/starship.toml`                            | Cross-shell prompt                      |
| `git/`      | `~/.config/git/config`                               | Git config + aliases                    |
| `claude/`   | `~/.claude/settings.json`, `~/.claude/statusline.sh` | Claude Code config + status line        |

## Fresh-Mac install

One command installs every tool and links every config:

```bash
git clone https://github.com/jmuncor/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./init.sh
```

[`init.sh`](init.sh) is safe to re-run. It:

1. installs **Homebrew** if missing,
2. installs all tools + the Lilex Nerd Font from the [`Brewfile`](Brewfile),
3. clones **TPM** (tmux plugin manager),
4. symlinks every package with `stow`,
5. sets Homebrew bash as the login shell.

Then there are two things to do by hand: open a terminal and press
<kbd>Ctrl+b</kbd> <kbd>I</kbd> to install the tmux plugins, and launch `nvim`
once to bootstrap lazy.nvim and the Mason LSPs (`:checkhealth` to verify).

### Manual stow (single package)

After editing one package you can relink just that one:

```bash
stow -t ~ --adopt <pkg> && git restore <pkg>   # e.g. nvim
stow -t ~ -D <pkg>                             # remove a package's links
```

`--adopt` pulls a pre-existing real file into the repo and links it back, then
`git restore` resets the repo copy to the committed version so the link points
at this repo's content (does nothing when there's nothing to adopt).

## Clipboard (OSC 52)

Copying in tmux reaches the system clipboard through OSC 52: `tmux.conf` passes
the escape sequence through (`set-clipboard on`, `allow-passthrough on`) and
Alacritty has `osc52 = "CopyPaste"` enabled. This also makes copy work when you
SSH into a remote box from inside a Mac tmux pane.

## Neovim keybindings

| Key | Action |
|-----|--------|
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
|-----|--------|
| `Ctrl+b` | Prefix |
| `Prefix + I` | Install plugins |
| `Prefix + %` | Split panes left/right |
| `Prefix + "` | Split panes top/bottom |
| `Alt+H` / `Alt+L` | Previous / next window |
| `Prefix + Ctrl-h/j/k/l` | Resize current pane |
