#!/bin/bash

# Backup old configs
echo "Backing up old configs..."
mkdir -p ~/old-config-backup
mv ~/.bashrc ~/old-config-backup/ 2>/dev/null
mv ~/.gitconfig ~/old-config-backup/ 2>/dev/null
mv ~/AppData/Local/nvim ~/old-config-backup/ 2>/dev/null

# Restore bash
echo "Restoring bash config..."
cp bash/.bashrc ~/
cp bash/.bash_profile ~/ 2>/dev/null

# Restore git
echo "Restoring git config..."
cp git/.gitconfig ~/

# Restore neovim
echo "Restoring neovim config..."
cp -r nvim ~/AppData/Local/

# Restore VS Code
echo "Restoring VS Code config..."
cp vscode/settings.json ~/AppData/Roaming/Code/User/
cp vscode/keybindings.json ~/AppData/Roaming/Code/User/
cp -r vscode/snippets ~/AppData/Roaming/Code/User/

# Install VS Code extensions
echo "Installing VS Code extensions..."
while read extension; do
  code --install-extension "$extension"
done < vscode/extensions.txt

echo "✅ Setup complete!"
