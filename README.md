# Dotfiles

My dotfiles for macOS and RHEL. Everything lives in this repo as GNU Stow
packages, and [`init.sh`](init.sh) is the entrypoint I use on a fresh machine.
It checks the OS and then runs the right bootstrap script. The setup is
deliberately minimal: stock tools, no plugins, nothing that needs extra repos.

The one exception is [herdr](https://herdr.dev), the multiplexer, which
replaced tmux. It is macOS-only in practice: upstream publishes an arm64 macOS
build and Homebrew has no Linux bottle, so RHEL boxes get the configs without a
multiplexer. See [Multiplexer](#multiplexer).

## Fresh Mac

```bash
git clone https://github.com/jmuncor/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./init.sh
```

On macOS this ends up running `script/bootstrap macos`. That script:

1. installs Homebrew if it is missing,
2. runs `brew bundle` using [`Brewfile`](Brewfile),
3. stows the packages listed in [`stow-packages.txt`](stow-packages.txt),
4. installs the herdr Claude Code integration and rewrites its hook path to a
   `$HOME`-relative one so the tracked `settings.json` stays portable,
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
3. warns that herdr is unavailable on RHEL,
4. backs up the stock `~/.bashrc` and `~/.bash_profile` to
   `*.before-dotfiles` if needed,
5. stows the packages listed in [`stow-packages.txt`](stow-packages.txt),
6. shows the backup paths and asks whether to delete them.

The RHEL package list is just my baseline. It is not supposed to match the
Mac Brewfile one-for-one.

## Manual follow-up

After setup I still do these by hand:

1. Open a fresh shell. herdr starts on its own from `~/.bashrc`.
2. On the Mac: `open terminal/OneDark.terminal`, then set the "OneDark"
   profile as default in Terminal → Settings → Profiles.
3. In the same Terminal profile, turn on "Use Option as Meta key" under
   Keyboard, or <kbd>Alt-H</kbd> and <kbd>Alt-L</kbd> will not switch tabs.
4. `gh auth login`, then sign in to Tailscale from the menu bar so the
   homelab is reachable. Both keep their credentials outside this repo.

## Stow layout

Each top-level folder is a Stow package that mirrors paths under `$HOME`:

| Package | Stows to | Purpose |
| --- | --- | --- |
| `bash/` | `~/.bashrc`, `~/.bash_profile` | Shell config |
| `claude/` | `~/.claude/settings.json`, `~/.claude/statusline.sh` | Claude Code config (generated keys are stripped on the way into git — see [Secrets](#secrets)) |
| `git/` | `~/.config/git/config` | Git config |
| `herdr/` | `~/.config/herdr/config.toml` | Multiplexer config |
| `starship/` | `~/.config/starship.toml` | Prompt config |
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

### Folded directories

Stow folds a whole package directory into a single symlink when the target does
not exist yet. On a clean box that turns `~/.claude` into a link straight at
this repo, and Claude Code then writes session transcripts, history, and
telemetry *inside the repo*, where only `.gitignore` keeps them out of commits.
`~/.config/herdr` has the same problem with sockets and logs.

`script/stow` creates those two directories up front so Stow links the tracked
files individually instead of folding. If one is already folded it says so and
points at the repair:

```bash
script/unfold ~/.claude
```

That moves the untracked runtime state back into `$HOME`, leaves the tracked
files in the repo, and re-stows the package. Quit the app that owns the
directory first — `script/unfold` asks before it touches anything.

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

### Claude Code settings are public

`claude/.claude/settings.json` is tracked, and this repo is public. Claude Code
writes generated state into that same file — `autoMode` in particular is a
briefing about whichever private project was open at the time, listing repo
paths, CI secret *names*, and branch-protection posture. No credential values,
but not something to publish either.

It cannot simply be moved aside. Claude Code reads `settings.local.json` only
inside a project directory, **not** at `~/.claude`; parking the block there
silently reverts auto mode to its shipped defaults. Verified with
`claude auto-mode config`, which prints the effective config — the block has to
stay in `settings.json` on disk.

So git carries a stripped copy instead. Two layers, both installed by
`script/bootstrap`:

- **[`script/claude-settings-filter`](script/claude-settings-filter)** is a git
  clean filter, wired up by [`.gitattributes`](.gitattributes). It removes the
  local-only keys from the content being staged and leaves the file on disk
  untouched, so Claude Code keeps reading them. Non-JSON input passes through
  unchanged rather than risking a mangled settings file.
- **`script/hooks/pre-commit`** refuses any commit whose staged `settings.json`
  still carries a local-only key or an absolute `/Users`/`/home` path. It should
  never fire; it covers a fresh clone where the filter is not configured yet.

Both are local git config (`core.hooksPath`, `filter.claude-settings.clean`),
which does not travel with a clone — hence re-running on every bootstrap. To set
them up by hand:

```bash
git config core.hooksPath script/hooks
git config filter.claude-settings.clean script/claude-settings-filter
git config filter.claude-settings.smudge cat
git add --renormalize claude/.claude/settings.json
```

A useful side effect: with the filter on, `settings.json` stops showing up dirty
in `git status` every time Claude Code rewrites its generated block.

Adding a new local-only key means listing it in both `LOCAL_ONLY_KEYS` arrays —
one in the filter, one in the hook.

## Multiplexer

herdr replaced tmux because it tracks which pane is running which Claude Code
session and shows in the sidebar which agent is working and which is waiting on
me. tmux cannot do that natively.

What that costs:

- **macOS only.** Homebrew builds it from source with no Linux bottle, so the
  RHEL bootstrap warns and moves on. Those boxes now have no multiplexer; long
  remote work needs `herdr --remote` from the Mac, or tmux installed by hand.
- **No `vim-tmux-navigator`.** <kbd>Ctrl-h/j/k/l</kbd> still moves between Vim
  windows and <kbd>Prefix</kbd> + <kbd>h/j/k/l</kbd> between panes, but the two
  are no longer one seamless motion.
- **Version 0.9.** It updates itself and rewrites
  `~/.claude/hooks/herdr-agent-state.sh` when it does, which is why that file is
  untracked and the hook path in `settings.json` is `$HOME`-relative.

`herdr config check` validates the config. It catches unknown keys, bad theme
names, and bad keybindings, but it does **not** validate color values — a
misspelled color is silently ignored, which is why the theme is written as hex.

To keep it running across reboots without opening a terminal:
`brew services start herdr`.

### Status bar

The bar sits on top, the way `status-position top` had it in tmux, and its
right side reads `76%  Thu Sep 18  1:02 PM`.

The clock is herdr's built-in `datetime` entry. Battery is not built in —
herdr's status types are `zoom`, `hostname`, `datetime`, `text`, and `command` —
so the percentage comes from a `command` entry running `pmset` through `awk`
once a minute. A ⚡ prefix means plugged in, covering charging, fully charged,
and the "paused at 80%" state battery optimization produces.

Worth knowing: command entries are evaluated on the herdr **server**, not the
client. Under `herdr --remote` the segment reports the far host, so attaching to
a Linux box leaves it blank rather than showing this laptop's charge.

## Clipboard

herdr copies mouse selections straight to the macOS clipboard (`copy_on_select`,
on by default), so local copy needs no plugin now that tmux-yank is gone.

Terminal.app still does not support OSC 52, so copying from a remote shell back
to the local clipboard does not work. That needs an OSC 52 capable terminal
(iTerm2, kitty).

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

## herdr keybindings

Splits, resize, and window switching keep the tmux keys. Tabs are the closest
thing to what tmux called windows.

| Key | Action |
| --- | --- |
| `Ctrl-b` | Prefix |
| `Prefix + %` | Split panes left/right |
| `Prefix + "` | Split panes top/bottom |
| `Prefix + h/j/k/l` | Move between panes |
| `Prefix + Ctrl-h/j/k/l` | Resize current pane |
| `Alt-H` / `Alt-L` | Previous / next tab |
| `Prefix + c` | New tab |
| `Prefix + ,` | Rename tab |
| `Prefix + 1..9` | Jump to tab |
| `Prefix + d` | Detach |
| `Prefix + z` | Zoom pane |
| `Prefix + x` | Close pane |
| `Prefix + b` | Toggle sidebar |
| `Prefix + w` | Workspace picker |
| `Prefix + Shift-G` | New git worktree |
| `Prefix + ?` | All keybindings |
