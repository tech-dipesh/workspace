#!/bin/bash
set -euo pipefail

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "==> Updating Homebrew..."
brew update && brew upgrade

# Base CLI tools
brew install git neovim wget curl node@20 python@3.12 openjdk@17 maven mysql postgresql@16 mongosh mongodb-community docker

# Docker Desktop (cask)
brew install --cask docker

# GUI apps via Homebrew Cask
brew install --cask \
  firefox \
  vlc \
  tableplus \
  bruno \
  gedit \            # or use 'textedit' built-in
  freefilesync \
  cisco-packet-tracer  # might require manual download; otherwise comment out

# Quick Share – Snapdrop (PWA) or install via cask
brew install --cask snapdrop

# Sysinfo
echo "==> System Info..."
system_profiler SPSoftwareDataType SPHardwareDataType
echo "Public IP: $(curl -s ifconfig.me)"

echo "==> Done. Log out and back in for all changes."
