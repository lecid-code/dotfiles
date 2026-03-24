# dotfiles

Personal dotfiles for Fedora Linux, managed with a bare git repository.

## Overview

This repository uses the **bare git repository approach** — no symlinks, no stow.
The repo lives at `~/.cfg` and the work tree is `$HOME`.

Packages are installed via **DNF** (system tools) and **cargo** (tools
not in Fedora repos). Language runtimes are managed by **mise**.

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

This script installs all tools via DNF and cargo, installs mise, and sets fish as
the default shell.

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

### Update mise runtimes

```bash
mise upgrade
```
