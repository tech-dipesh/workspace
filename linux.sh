#!/bin/bash

HOME_DIR="$HOME"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
VSCODE_CONFIG_DIR="$HOME/.config/Code/User"

mkdir -p ~/old-config-backup

[ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" ~/old-config-backup/
[ -f "$HOME/.gitconfig" ] && mv "$HOME/.gitconfig" ~/old-config-backup/
[ -d "$NVIM_CONFIG_DIR" ] && mv "$NVIM_CONFIG_DIR" ~/old-config-backup/

[ -f "bash/.bashrc" ] && cp bash/.bashrc "$HOME/"
[ -f "bash/.bash_profile" ] && cp bash/.bash_profile "$HOME/"

[ -f "git/.gitconfig" ] && cp git/.gitconfig "$HOME/"

# FIX: Create the parent .config folder structure first
mkdir -p "$HOME/.config"
[ -d "nvim" ] && cp -r nvim "$NVIM_CONFIG_DIR"

mkdir -p "$VSCODE_CONFIG_DIR"
[ -f "Vs_Code/User/settings.json" ] && cp Vs_Code/User/settings.json "$VSCODE_CONFIG_DIR/"
[ -f "Vs_Code/User/keybindings.json" ] && cp Vs_Code/User/keybindings.json "$VSCODE_CONFIG_DIR/"
[ -d "Vs_Code/User/snippets" ] && cp -r Vs_Code/User/snippets "$VSCODE_CONFIG_DIR/"

if [ -f "Vs_Code/extensions.txt" ] && command -v code &> /dev/null; then
  while read extension; do
    code --install-extension "$extension" --force
  done < Vs_Code/extensions.txt
fi

echo "✅ Linux setup complete!"

