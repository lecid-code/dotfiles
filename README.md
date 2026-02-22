# dotfiles

Personal dotfiles for Fedora Linux, managed with a bare git repository and [Home Manager](https://github.com/nix-community/home-manager).

## Overview

This repository uses the **bare git repository approach** — no symlinks, no stow. The repo lives at `~/.cfg` and the work tree is `$HOME`.

Configuration is split between:
- **Home Manager** — tools, shell, and user-level config managed declaratively via Nix
- **Bare repo** — dotfiles that live outside Home Manager (Neovim/LazyVim, bun completions, mise, lazygit)

---

## Tools

### Managed by Home Manager (Nix)

| Tool | Purpose |
|------|---------|
| [fish](https://fishshell.com) | Shell |
| [starship](https://starship.rs) | Prompt |
| [neovim](https://neovim.io) | Editor (binary only — config managed by LazyVim) |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [git](https://git-scm.com) | Version control |
| [delta](https://github.com/dandavison/delta) | Git diff pager |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [mise](https://mise.jdx.dev) | Language runtime manager |
| [eza](https://github.com/eza-community/eza) | `ls` replacement |
| [bat](https://github.com/sharkdp/bat) | `cat` replacement |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager |
| [fd](https://github.com/sharkdp/fd) | `find` replacement |
| [jq](https://stedolan.github.io/jq/) | JSON processor |
| [yq-go](https://github.com/mikefarah/yq) | YAML processor |
| [procs](https://github.com/dalance/procs) | `ps` replacement |
| [bottom](https://github.com/ClementTsang/bottom) | System monitor (`btm`) |
| [dust](https://github.com/bootandy/dust) | `du` replacement |
| [duf](https://github.com/muesli/duf) | `df` replacement |
| [gping](https://github.com/orf/gping) | `ping` with graph |
| [hyperfine](https://github.com/sharkdp/hyperfine) | Benchmarking |
| [tealdeer](https://github.com/dbrgn/tealdeer) | `tldr` client |
| [gh](https://cli.github.com) | GitHub CLI |
| [glab](https://gitlab.com/gitlab-org/cli) | GitLab CLI |

---

## Structure

```
~/.config/home-manager/
├── home.nix                  # Top-level — imports only
└── modules/
    ├── packages.nix          # home.packages
    ├── shell.nix             # fish, starship, aliases, functions, env vars
    ├── git.nix               # git + delta
    ├── editor.nix            # neovim
    └── terminal.nix          # tmux, eza, fzf, bat, zoxide, yazi
```

---

## Daily Workflow

### Editing config

```fish
hme          # opens home-manager config in $EDITOR
```

### Applying changes

```fish
hms "description of change"
```

This runs `home-manager switch`, then commits all files under `~/.config/home-manager/` to the dotfiles repo.

### Managing dotfiles repo

```fish
cfg status
cfg add <file>
cfg commit -m "message"
cfg push
```

`cfg` is a Fish function wrapping `git --git-dir=$HOME/.cfg --work-tree=$HOME`.

---

## Bootstrap a New Machine

### 1. Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2. Install Home Manager

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

### 3. Clone dotfiles repo

```bash
git clone --bare https://github.com/lecid-code/dotfiles.git $HOME/.cfg
alias cfg='git --git-dir=$HOME/.cfg --work-tree=$HOME'
cfg checkout
cfg config --local status.showUntrackedFiles no
```

### 4. Apply Home Manager config

```bash
home-manager switch
```

### 5. Set Fish as login shell

```bash
chsh -s $(which fish)
```

### 6. Install mise runtimes

```bash
mise install
```

---

## Maintenance

### Garbage collect Nix store

```bash
nix-collect-garbage -d
nix store optimise
```

A cron job runs this automatically every Sunday at 3am.

### Update Home Manager and packages

```bash
nix-channel --update
hms "update packages"
```

### Update mise runtimes

```bash
mise upgrade
```
