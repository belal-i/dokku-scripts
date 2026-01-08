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
