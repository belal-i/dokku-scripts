create_app() {
  local app="$1"
  dokku apps:create "$app" || true
}

deploy_app() {
  local app="$1"
  local domain="$2"
  local version="$3"
  local image="${APP_IMAGE[$app]:-$app}"
  # TODO: Idempotency! Right now, it keeps creating new containers.
  dokku git:from-image "$app" "${image}:${version}"
  dokku domains:add "$app" "$domain"
  dokku domains:remove "$app" "${app}.${domain}"
}

mount_volumes() {
  local app="$1"
  declare -n volumes="APP_VOLUMES_${app}"

  for host_path in "${!volumes[@]}"; do
    container_path="${volumes[$host_path]}"

    echo "Mounting $host_path -> $container_path"

    mkdir -p "$host_path"
    dokku storage:mount "$app" "$host_path:$container_path"
  done
}

map_port() {
  local app="$1"

  if [[ ! -z "${APP_PORT_MAPPING[$app]}" ]]; then
    dokku ports:add "$app" "http:80:${APP_PORT_MAPPING[$app]}"
  fi
}
