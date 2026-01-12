#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="$HOME/.local"
LIB_DIR="$INSTALL_ROOT/lib/dokku-scripts"
BIN_DIR="$INSTALL_ROOT/bin"

echo "[*] Installing dokku-scripts"

# install libs
mkdir -p "$LIB_DIR"
cp -r ./lib/* "$LIB_DIR/"
wget -O "$LIB_DIR/shflags" https://raw.githubusercontent.com/kward/shflags/master/shflags
chmod 755 "$LIB_DIR/shflags"

# install executable
cp ./bin/dokku-setup "$BIN_DIR/dokku-setup"
chmod 755 "$BIN_DIR/dokku-setup"

echo "[✓] Installed dokku-setup to $BIN_DIR"
