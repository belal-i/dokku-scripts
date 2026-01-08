#!/bin/bash

set -eo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi

log() {
  echo "==> $*"
}

install_plugin() {
  local url="$1"
  if ! dokku plugin:list | grep -q "$(basename "$url" .git)"; then
    dokku plugin:install "$url"
  else
    log "Plugin already installed: $url"
  fi
}

# Defaults
DOKKU_TAG="v0.37.4"
DATABASE_TYPE="mysql"
DOMAIN=""

while getopts "d:t:p:" opt; do
  case "$opt" in
    d) DOMAIN="$OPTARG" ;;
    t) DOKKU_TAG="$OPTARG" ;;
    p) DATABASE_TYPE="$OPTARG" ;;
    *)
      echo "Usage: $0 -d <domain> [-t dokku_tag] [-p database_plugin]"
      exit 1
      ;;
  esac
done

if [ -z "$DOMAIN" ]; then
  echo "Error: domain is required"
  echo "Usage: $0 -d <domain> [-t dokku_tag] [-p database_plugin]"
  exit 1
fi

log "Installing Dokku"
log "  Domain: $DOMAIN"
log "  Dokku tag: $DOKKU_TAG"
log "  Database plugin: $DATABASE_TYPE"

wget -NP . "https://dokku.com/install/$DOKKU_TAG/bootstrap.sh"
DOKKU_TAG="$DOKKU_TAG" bash bootstrap.sh

# SSH key
if [[ -f /root/.ssh/authorized_keys ]]; then
  dokku ssh-keys:add admin < /root/.ssh/authorized_keys
else
  log "No authorized_keys found, skipping SSH key import"
fi


# Domain
dokku domains:set-global "$DOMAIN"

# Install needed plugins.
install_plugin "https://github.com/dokku/dokku-${DATABASE_TYPE}.git"
install_plugin "https://github.com/dokku/dokku-letsencrypt.git"
