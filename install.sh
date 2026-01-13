#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/belal-i/dokku-scripts.git"
INSTALL_ROOT="/usr/local"
LIB_DIR="$INSTALL_ROOT/lib/dokku-scripts"
BIN_DIR="$INSTALL_ROOT/bin"

echo "[*] Installing dokku-scripts"

# temp dir
TMP_DIR="$(mktemp -d)"
trap '[[ -n "$TMP_DIR" ]] && rm -rf "$TMP_DIR"' EXIT

git clone "$REPO_URL" "$TMP_DIR"

# install libs
mkdir -p "$LIB_DIR"
cp -r "$TMP_DIR/lib/"* "$LIB_DIR/"
wget -O "$LIB_DIR/shflags" https://raw.githubusercontent.com/kward/shflags/master/shflags
chmod 755 "$LIB_DIR/shflags"

# install executable
cp "$TMP_DIR/bin/dokku-setup" "$BIN_DIR/dokku-setup"
chmod 755 "$BIN_DIR/dokku-setup"

echo "[✓] Installed dokku-setup to $BIN_DIR"
