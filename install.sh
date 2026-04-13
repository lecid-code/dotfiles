#!/bin/bash
set -e

# 1. Check for existing setup immediately
if [ -d "$HOME/.cfg" ]; then
  echo "Configuration (.cfg) already exists. Skipping setup."
  exit 0
fi

# 2. System Updates & Repos
sudo dnf update -y

# 3. Install development toolchain and CLI Tools
sudo dnf group install -y development-tools
sudo dnf install -y fish tealdeer tmux

# 4. Install mise
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
fi

echo "Packages installed. Initializing dotfiles..."

# 5. Clone and Checkout Dotfiles
git clone --bare git@github.com:lecid-code/dotfiles.git $HOME/.cfg

# Define a temporary function for the bare repo commands
function config {
  /usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME "$@"
}

# Force checkout to overwrite default system files (like .bashrc)
config checkout -f
config config --local status.showUntrackedFiles no

# 6. Final System Changes
sudo chsh -s "$(which fish)" "$USER"
$HOME/.local/bin/mise install

echo "Setup complete. Fish shell is now default. Please restart your session."
