#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REF=v0.6.0
REF="${DOKKU_SCRUBS_VERSION:-$DEFAULT_REF}"

REPO_URL="https://github.com/belal-i/dokku-scrubs.git"
INSTALL_ROOT="/usr/local"
LIB_DIR="$INSTALL_ROOT/lib/dokku-scrubs"
BIN_DIR="$INSTALL_ROOT/bin"
ETC_DIR="$INSTALL_ROOT/etc"

echo "[*] Installing dokku-scrubs ($REF)"

# temp dir
TMP_DIR="$(mktemp -d)"
trap '[[ -n "$TMP_DIR" ]] && rm -rf "$TMP_DIR"' EXIT

git clone \
  --depth 1 \
  --branch "$REF" \
  "$REPO_URL" \
  "$TMP_DIR"

# install libs
mkdir -p "$LIB_DIR"
cp -r "$TMP_DIR/lib/"* "$LIB_DIR/"
wget -O "$LIB_DIR/shflags" https://raw.githubusercontent.com/kward/shflags/master/shflags
chmod 755 "$LIB_DIR/shflags"

# copy config files
mkdir -p "$ETC_DIR"
cp -r "$TMP_DIR/etc/"* "$ETC_DIR/"

# install executable
cp "$TMP_DIR/bin/dokku-scrubs" "$BIN_DIR/dokku-scrubs"
chmod 755 "$BIN_DIR/dokku-scrubs"

echo "[✓] Installed dokku-scrubs ($REF) to $BIN_DIR"
