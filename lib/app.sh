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

  local image_ref="${APP_IMAGE[$app]:-$app}:${version}"

  build_domains "$raw_domain" "$wwwsubdomain"

  # Deploy app from image, if it has changed.
  if ! dokku git:report "$app" --git-source-image | grep -qF "$image_ref"; then
    dokku git:from-image "$app" "$image_ref"
  fi

  # Configure domains
  dokku domains:add "$app" "${DOMAINS[@]}"
  for domain in "${DOMAINS[@]}"; do
    dokku domains:remove "$app" "${app}.${domain}" || true
  done
}

mount_volumes() {
  local app="$1"
  local version="$2"

  declare -n volumes="APP_VOLUMES_${app}"

  for host_path in "${!volumes[@]}"; do
    container_path="${volumes[$host_path]}"

    # TODO: Use dokku storage:create instead?
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
    # TODO: We can query existing entries with:
    # dokku storage:list-entries "$app" --format json
    dokku storage:mount "$app" "$host_path:$container_path" || true
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
