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

  local image_ref="${APP_IMAGE[$app]:-$app}:${version}"

  # Clear global domains from potential previous runs.
  # Fixes idempotency and secondary apps.
  dokku domains:clear-global

  # Deploy app from image, if it has changed.
  if ! dokku git:report "$app" --git-source-image | grep -qF "$image_ref"; then
    dokku git:from-image "$app" "$image_ref"
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

storage_mount_exists() {
  local app="$1"
  local host_path="$2"
  local container_path="$3"

  dokku storage:list "$app" --format json |
    jq -e \
      --arg host_path "$host_path" \
      --arg container_path "$container_path" \
      '.[] | select(
        .host_path == $host_path and
        .container_path == $container_path
      )' \
      >/dev/null
}

mount_volumes() {
  local app="$1"
  local version="$2"

  declare -n volumes="APP_VOLUMES_${app}"

  for host_path in "${!volumes[@]}"; do
    local container_path="${volumes[$host_path]}"

    if storage_mount_exists "$app" "$host_path" "$container_path"; then
      log "$host_path -> $container_path already mounted, skipping."
      continue
    fi

    log "Mounting $host_path -> $container_path ..."

    dokku storage:create "$app" "$host_path"

    # App specific cases
    # Drupal (see https://github.com/docker-library/drupal/issues/3 )
    if [[ "$app" == "drupal" && "$container_path" == "/var/www/html/sites" ]]; then
      # Only initialize newly created storage directory, never overwrite existing data.
      if [[ -z "$(find "$host_path" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
        log "Initializing Drupal sites directory"

        docker run --rm \
          "${APP_IMAGE[$app]}:${version}" \
          tar -cC /var/www/html/sites . |
          tar -xC "$host_path"
      fi
    fi

    dokku storage:mount "$app" "$host_path:$container_path"

    log "... $host_path -> $container_path mounted."
  done
}

map_port() {
  local app="$1"

  if [[ ! -z "${APP_PORT_MAPPING[$app]}"  ]]; then
    local port="${APP_PORT_MAPPING[$app]}"

    if ! dokku ports:report "$app" --ports-map | grep -qF "http:80:${port}"; then
      dokku ports:add "$app" "http:80:${port}"
    fi
  fi
}
