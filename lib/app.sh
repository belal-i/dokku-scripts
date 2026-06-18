create_app() {
  local app="$1"

  dokku apps:exists "$app" >/dev/null 2>&1 \
    || dokku apps:create "$app"
}

deploy_app() {
  local app="$1"
  local raw_domain="$2"
  local wwwsubdomain="$3"
  local version="$4"

  local image="${APP_IMAGE[$app]:-$app}"

  build_domains "$raw_domain" "$wwwsubdomain"

  # Deploy app from image
  # TODO: This could be more robust, but there is currently no convenient
  # API to check this.
  if ! dokku git:from-image "$app" "${image}:${version}"; then
    log "${image}:${version} already deployed, continuing"
  fi

  # Configure domains
  dokku domains:add "$app" "${DOMAINS[@]}"
  dokku domains:remove "$app" "${app}.${raw_domain}"
}

mount_volumes() {
  local app="$1"
  declare -n volumes="APP_VOLUMES_${app}"

  for host_path in "${!volumes[@]}"; do
    container_path="${volumes[$host_path]}"

    echo "Mounting $host_path -> $container_path"

    mkdir -p "$host_path"
    # TODO: Make it more robust, but Dokku currently doesn't
    # expose a convenient API to check this.
    dokku storage:mount "$app" "$host_path:$container_path" || true
  done
}

map_port() {
  local app="$1"

  if [[ ! -z "${APP_PORT_MAPPING[$app]}" ]]; then
    dokku ports:add "$app" "http:80:${APP_PORT_MAPPING[$app]}"
  fi
}
