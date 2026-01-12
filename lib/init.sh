set -eo pipefail

usage() {
    cat <<EOF
Usage:
  dokku-setup -a <app> -d <domain> [options]

Required:
  -a <app>        Application type (wordpress, joomla, ...)
  -d <domain>     Domain name

Optional:
  -t <tag>        Dokku version tag
  -p <db>         Database plugin (default: mysql)
  -l              Enable SSL with letsencrypt (subject to rate limits)
  -e              Email, required if running with -l
EOF
  exit 1
}

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
  fi
}

# TODO
#require_args() {
#  local missing=()
#
#  for var in "$@"; do
#    if [[ "$var" -eq "" ]]; then
#      missing+=("$var")
#    fi
#  done
#
#  if (( ${#missing[@]} > 0 )); then
#    echo "Error: missing required arguments:" >&2
#    for m in "${missing[@]}"; do
#      echo "  - $m" >&2
#    done
#    echo >&2
#    usage
#  fi
#}

install_plugin() {
  local plugin="$1"
  local url="$2"
  if ! dokku plugin:list | grep "$plugin"; then
    dokku plugin:install "$url"
  else
    log "Plugin already installed: $plugin"
  fi
}

init_dokku() {
  local domain="$1"
  local dokku_tag="$2"
  local database="$3"

  log "Installing Dokku"
  log "  Domain: $domain"
  log "  Dokku tag: $dokku_tag"
  log "  Database : $database"

  wget -NP . "https://dokku.com/install/$dokku_tag/bootstrap.sh"
  DOKKU_TAG="$dokku_tag" bash bootstrap.sh

  # SSH key
  # TODO: Maybe don't even need this...
  if [[ -f /root/.ssh/authorized_keys ]]; then
    cat /root/.ssh/authorized_keys | dokku ssh-keys:add admin || true
  else
    log "No authorized_keys found, skipping SSH key import"
  fi


  # Domain
  dokku domains:set-global "$domain"

  # Install needed plugins.
  install_plugin "$database" "https://github.com/dokku/dokku-${database}.git"
  install_plugin "letsencrypt" "https://github.com/dokku/dokku-letsencrypt.git"
}
