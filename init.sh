#!/bin/bash

DOKKU_TAG=v0.37.4

# Change this to the domain you have.
DOMAIN=yourserver.com

DATABASE_PLUGIN=mysql

wget -NP . https://dokku.com/install/$DOKKU_TAG/bootstrap.sh
bash bootstrap.sh

# SSH key
cat .ssh/authorized_keys | dokku ssh-keys:add  admin

# Domain
dokku domains:set-global $DOMAIN

# Install needed plugins - PostgreSQL or similar should work too, but YMMV.
dokku plugin:install https://github.com/dokku/dokku-$DATABASE_PLUGIN.git
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
