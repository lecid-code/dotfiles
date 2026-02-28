# dotfiles

Personal dotfiles for Fedora Linux, managed with a bare git repository.

## Overview

This repository uses the **bare git repository approach** — no symlinks, no stow. The repo lives at `~/.cfg` and the work tree is `$HOME`.

Packages are installed via **DNF** (system tools) and **cargo** (tools not in Fedora repos). Language runtimes are managed by **mise**.

---

## Tools

| Tool | Purpose | Source |
|------|---------|--------|
| [fish](https://fishshell.com) | Shell | DNF |
| [neovim](https://neovim.io) | Editor | DNF |
| [git](https://git-scm.com) | Version control | DNF |
| [delta](https://github.com/dandavison/delta) | Git diff pager | DNF (`git-delta`) |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI | DNF |
| [mise](https://mise.jdx.dev) | Language runtime manager | curl installer |
| [eza](https://github.com/eza-community/eza) | `ls` replacement | cargo |
| [bat](https://github.com/sharkdp/bat) | `cat` replacement | DNF |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | DNF |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` | DNF |
| [atuin](https://github.com/atuinsh/atuin) | Shell history | DNF |
| [navi](https://github.com/denisidoro/navi) | Cheatsheet widget | DNF |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager | cargo (`yazi-fm`) |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info | DNF |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep | DNF |
| [fd](https://github.com/sharkdp/fd) | `find` replacement | DNF (`fd-find`) |
| [procs](https://github.com/dalance/procs) | `ps` replacement | DNF |
| [dust](https://github.com/bootandy/dust) | `du` replacement | DNF (`du-dust`) |
| [duf](https://github.com/muesli/duf) | `df` replacement | DNF |

---

## Fish Config Structure

```
~/.config/fish/
├── config.fish               # Env vars, PATH, login shell init
├── conf.d/
│   ├── 00-path.fish          # PATH setup (loads first)
│   └── 01-terminal.fish      # Tool integrations (mise, atuin, fzf, zoxide, navi)
├── functions/                # One file per function (autoloaded)
│   ├── cfg.fish
│   ├── hms.fish
│   ├── load_env.fish
│   ├── reload.fish
│   └── y.fish                # Yazi shell wrapper
└── fish_variables            # DO NOT commit — in .gitignore
```

### Key functions

- **`cfg`** — wraps `git --git-dir=$HOME/.cfg --work-tree=$HOME` for managing dotfiles
- **`y`** — yazi wrapper that changes directory on exit
- **`load_env`** — loads a `.env` file into the current shell session
- **`reload`** — re-sources `config.fish` without restarting the shell

---

## Git Config Structure

```
~/.gitconfig                  # Git settings, aliases, delta integration
~/.config/git/ignore          # Global gitignore
```

---

## Bootstrap a New Machine

### 1. Clone dotfiles repo

```bash
git clone --bare https://github.com/lecid-code/dotfiles.git $HOME/.cfg
alias cfg='git --git-dir=$HOME/.cfg --work-tree=$HOME'
cfg checkout
cfg config --local status.showUntrackedFiles no
```

### 2. Run bootstrap script

```bash
bash ~/bootstrap.sh
```

This script installs all tools via DNF and cargo, installs mise, and sets fish as the default shell.

### 3. Install mise runtimes

```bash
mise install
```

### 4. Restart your terminal

---

## Managing Dotfiles

```fish
cfg status
cfg add <file>
cfg commit -m "message"
cfg push
```

---

## Maintenance

### Update system packages

```bash
sudo dnf upgrade
```

### Update cargo tools

```bash
cargo install eza yazi-fm  # re-run to update
```

### Update mise runtimes

```bash
mise upgrade
```
