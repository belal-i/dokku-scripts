create_app() {
  local app="$1"

  dokku apps:exists "$app" >/dev/null 2>&1 \
    || dokku apps:create "$app"
}

deploy_app() {
  local app="$1"
  local raw_domain="$2"
  local wwwsubdomain="$3"
  local secondary="$4"
  local version="$5"

  local image="${APP_IMAGE[$app]:-$app}"

  # Clear global domains from potential previous runs.
  # Fixes idempotency and secondary apps.
  dokku domains:clear-global

  # Deploy app from image
  # TODO: This could be more robust, but there is currently no convenient
  # API to check this.
  if ! dokku git:from-image "$app" "${image}:${version}"; then
    log "git:from-image failed, continuing (idempotency workaround)"
  fi

  # Configure domains, unless we're installing a secondary app.
  if [[ ! "$secondary" -eq ${FLAGS_TRUE} ]]; then
    build_domains "$raw_domain" "$wwwsubdomain"
    dokku domains:add "$app" "${DOMAINS[@]}"
    for domain in "${DOMAINS[@]}"; do
      dokku domains:remove "$app" "${app}.${domain}" || true
    done
  fi
}

mount_volumes() {
  local app="$1"
  local version="$2"

  declare -n volumes="APP_VOLUMES_${app}"

  for host_path in "${!volumes[@]}"; do
    container_path="${volumes[$host_path]}"

    mkdir -p "$host_path"

    # App specific cases
    # Drupal (see https://github.com/docker-library/drupal/issues/3 )
    if [[ "$app" == "drupal" && "$container_path" == "/var/www/html/sites" ]]; then
      # Making sure we don't overwrite user data with new image initialization!
      if [[ -z "$(find "$host_path" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
        log "Initializing Drupal sites directory"

        docker run --rm \
          "${APP_IMAGE[$app]}:${version}" \
          tar -cC /var/www/html/sites . |
          tar -xC "$host_path"
      fi
    fi

    log "Mounting $host_path -> $container_path"

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
