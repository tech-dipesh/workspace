#!/bin/bash
set -euo pipefail

echo "==> Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "==> Installing base tools..."
sudo apt install -y \
  curl wget gnupg ca-certificates lsb-release \
  git neovim vlc firefox gedit \
  python3 python3-pip nodejs npm \
  openjdk-17-jdk maven \
  postgresql postgresql-client \
  mysql-server mysql-client \
  mongosh mongodb-server \
  docker.io docker-compose-v2

# Docker without sudo (requires logout/login)
sudo usermod -aG docker "$USER"

# Node version manager (optional, but recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Bruno (API client) – AppImage
echo "==> Installing Bruno..."
mkdir -p "$HOME/Applications"
wget -q "https://github.com/usebruno/bruno/releases/latest/download/bruno_amd64_linux.AppImage" \
  -O "$HOME/Applications/bruno.AppImage"
chmod +x "$HOME/Applications/bruno.AppImage"

# TablePlus – install from official repo
echo "==> Installing TablePlus..."
wget -qO - https://deb.tableplus.com/apt.tableplus.com.gpg.key | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://deb.tableplus.com/debian/22 tableplus main"
sudo apt update && sudo apt install -y tableplus

# Cisco Packet Tracer – manual download required (explain)
echo "==> Cisco Packet Tracer: Please download the .deb from https://www.netacad.com and install with:"
echo "    sudo dpkg -i PacketTracer_*.deb && sudo apt install -f"

# FreeFileSync (assuming "free boom share" is a typo for FreeFileSync)
echo "==> Installing FreeFileSync..."
wget -q "https://freefilesync.org/download/FreeFileSync_13.0_Linux.tar.gz" -O /tmp/ffs.tar.gz
tar -xzf /tmp/ffs.tar.gz -C "$HOME/Applications/"
echo "Run: $HOME/Applications/FreeFileSync/FreeFileSync"

# Quick Share (using GSConnect or `qr-filetransfer`)
echo "==> Quick Share: Install GSConnect from GNOME Extensions or use qr-filetransfer"
sudo apt install -y qr-filetransfer   # simple CLI file transfer via QR

# MongoDB Shell already installed via mongosh; MongoDB Compass optional
# sudo snap install mongodb-compass

# Sysinfo
echo "==> System Info..."
uname -a
lsb_release -a
echo "Public IP: $(curl -s ifconfig.me)"

echo "==> Done. Reboot or re-login recommended."
