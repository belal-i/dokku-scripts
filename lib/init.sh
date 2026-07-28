set -eo pipefail

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
  fi
}

install_plugin() {
  local plugin="$1"
  local url="$2"
  if ! dokku plugin:list | grep "$plugin"; then
    dokku plugin:install "$url"
  else
    log "Plugin already installed: $plugin"
  fi
}

init_system() {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  init_fail2ban
  # TODO: In the future, set up other system tools here.
}

init_fail2ban() {
  apt-get install -y fail2ban

  install -Dm644 \
    "$DOKKU_SCRUBS_ETC/jail.local" \
    /etc/fail2ban/jail.d/dokku-scrubs.local

  systemctl enable --now fail2ban
}

init_dokku() {
  local raw_domain="$1"
  local wwwsubdomain="$2"
  local dokku_tag="$3"
  local database="$4"

  build_domains "$raw_domain" "$wwwsubdomain"

  log "Installing Dokku"
  log "  Domains: ${DOMAINS[@]}"
  log "  Dokku tag: $dokku_tag"
  log "  Database : $database"

  wget -NP . "https://dokku.com/install/$dokku_tag/bootstrap.sh"
  DOKKU_TAG="$dokku_tag" bash bootstrap.sh

  # Domains
  dokku domains:set-global "${DOMAINS[@]}"

  # Install needed plugins.
  install_plugin "$database" "https://github.com/dokku/dokku-${database}.git"
  install_plugin "letsencrypt" "https://github.com/dokku/dokku-letsencrypt.git"
}
