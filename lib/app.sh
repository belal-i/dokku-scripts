create_app() {
  local app="$1"
  dokku apps:create "$app" || true
}

deploy_app() {
  local app="$1"
  local domain="$2"
  # TODO: Idempotency! Right now, it keeps creating new containers.
  dokku git:from-image "$app" "${APP_IMAGE[$app]}"
  dokku domains:add "$app" "$domain"
  dokku domains:remove "$app" "${app}.${domain}"
}

mount_volume() {
  local app="$1"
  local host_dir="/var/lib/dokku/data/storage/${app}"

  if [[ ! -z "${APP_VOLUME[$app]}" ]]; then
    mkdir -p "$host_dir"
    dokku storage:mount "$app" "${host_dir}:${APP_VOLUME[$app]}"
  fi
}

map_port() {
  local app="$1"

  if [[ ! -z "${APP_PORT_MAPPING[$app]}" ]]; then
    dokku ports:add "$app" "http:80:${APP_PORT_MAPPING[$app]}"
  fi
}
