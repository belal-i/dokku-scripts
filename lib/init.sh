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
  local app="$1"

  export DEBIAN_FRONTEND=noninteractive
  apt-get update

  apt-get install -y jq

  init_fail2ban "$app"
  # TODO: In the future, set up other system tools here.
}

init_fail2ban() {
  local app="$1"

  apt-get install -y fail2ban
  systemctl enable --now fail2ban

  local filter="${DOKKU_SCRUBS_ETC}/filter.d/${app}.conf"
  local jail="${DOKKU_SCRUBS_ETC}/jail.d/${app}.local"

  # Install global fail2ban jails.
  install -Dm644 \
    "$DOKKU_SCRUBS_ETC/jail.d/dokku-scrubs.local" \
    /etc/fail2ban/jail.d/dokku-scrubs.local

  # Install app specific fail2ban filter, if it exists.
  if [[ -f "$filter" ]]; then
    install -Dm644 \
      "$filter" \
      "/etc/fail2ban/filter.d/${app}.conf"
  fi

  # Install app specific fail2ban jail, if it exists.
  if [[ -f "$jail" ]]; then
    install -Dm644 \
      "$jail" \
      "/etc/fail2ban/jail.d/${app}.local"
  fi
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
