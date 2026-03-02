#!/bin/bash
set -e

# COPR repositories
sudo dnf copr enable lihaohong/yazi -y
sudo dnf copr enable atim/lazygit -y
sudo dnf copr enable gierth/tools-rust -y

# System tools via DNF
sudo dnf install -y --skip-unavailable \
  fish \
  neovim \
  git \
  git-delta \
  bat \
  fzf \
  zoxide \
  atuin \
  navi \
  lazygit \
  ripgrep \
  fd-find \
  fastfetch \
  procs \
  duf \
  du-dust \
  tree-sitter-cli \
  gcc \
  make \
  unzip \
  eza \
  yazi

# Install mise only if not already installed
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
fi

echo "Done. Restart your terminal."
