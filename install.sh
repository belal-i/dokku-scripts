#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/belal-i/dokku-scrubs.git"
INSTALL_ROOT="/usr/local"
LIB_DIR="$INSTALL_ROOT/lib/dokku-scrubs"
BIN_DIR="$INSTALL_ROOT/bin"

echo "[*] Installing dokku-scrubs"

# temp dir
TMP_DIR="$(mktemp -d)"
trap '[[ -n "$TMP_DIR" ]] && rm -rf "$TMP_DIR"' EXIT

git clone "$REPO_URL" "$TMP_DIR" --branch develop

# install libs
mkdir -p "$LIB_DIR"
cp -r "$TMP_DIR/lib/"* "$LIB_DIR/"
wget -O "$LIB_DIR/shflags" https://raw.githubusercontent.com/kward/shflags/master/shflags
chmod 755 "$LIB_DIR/shflags"

# install executable
cp "$TMP_DIR/bin/dokku-scrubs" "$BIN_DIR/dokku-scrubs"
chmod 755 "$BIN_DIR/dokku-scrubs"

echo "[✓] Installed dokku-scrubs to $BIN_DIR"
