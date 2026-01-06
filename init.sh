#!/bin/bash

set -e

# Defaults
DOKKU_TAG="v0.37.4"
DATABASE_PLUGIN="mysql"
DOMAIN=""

while getopts "d:t:p:" opt; do
  case "$opt" in
    d) DOMAIN="$OPTARG" ;;
    t) DOKKU_TAG="$OPTARG" ;;
    p) DATABASE_PLUGIN="$OPTARG" ;;
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

echo "Installing Dokku"
echo "  Domain: $DOMAIN"
echo "  Dokku tag: $DOKKU_TAG"
echo "  Database plugin: $DATABASE_PLUGIN"

wget -NP . https://dokku.com/install/$DOKKU_TAG/bootstrap.sh
bash bootstrap.sh

# SSH key
cat .ssh/authorized_keys | dokku ssh-keys:add  admin

# Domain
dokku domains:set-global $DOMAIN

# Install needed plugins - PostgreSQL or similar should work too, but YMMV.
dokku plugin:install https://github.com/dokku/dokku-$DATABASE_PLUGIN.git
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
