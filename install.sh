#!/bin/bash
set -e

# COPR repositories
sudo dnf copr enable atim/lazygit -y
sudo dnf copr enable gierth/tools-rust -y

# Update system to latest
sudo dnf update -y

# Install core development tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf groupinstall -y "C Development Tools and Libraries"

# Core CLI Tools
sudo dnf install -y \
  ripgrep fzf fish bat zoxide fd-find tealdeer unzip

# Tools from COPR
sudo dnf install -y \
  lazygit yazi eza jaq git-cliff hurl

echo "System updated and software installed..."

# Install mise only if not already installed
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
fi

git clone --bare https://github.com/lecid-code/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg --work-tree=$HOME checkout
git --git-dir=$HOME/.cfg --work-tree=$HOME config --local status.showUntrackedFiles no

echo "Dotfiles cloned..."

# Use full path for mise
$HOME/.local/bin/mise install

echo "Development tools installed..."

chsh -s $(which fish)

echo "Shell changed to Fish. Restart server."
