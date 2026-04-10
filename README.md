# dotfiles

Personal dotfiles for Fedora Linux, managed with a bare git repository.

## Overview

This repository uses the **bare git repository approach** — no symlinks, no stow.
The repo lives at `~/.cfg` and the work tree is `$HOME`.

Packages are installed via **DNF** (system tools) and language runtimes are managed by **mise**.

---

## Bootstrap a New Machine

```bash
curl -fsSL https://raw.githubusercontent.com/lecid-code/dotfiles/main/install.sh | bash
```

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
