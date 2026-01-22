setup_db() {
  local db="$1"
  local app="$2"
  local db_slug="${app}-db"
  local db_name="${app}_db"

  # Autogenerate, but restrict to alphanumeric characters,
  # to avoid URI parsing issues (Redmine, etc.)
  local db_password="$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 32)"

  # TODO: Idempotency
  dokku "$db:create" "$db_slug" --password "$db_password" || true
  dokku "$db:link" "$db_slug" "$app" || true


  #local dsn
  #dsn="$(dokku mysql:info "$db" --dsn)"

  dokku config:set "$app" \
    "${APP_DB_HOST_VAR[$app]}=dokku-${db}-${db_slug}" \
    "${APP_DB_NAME_VAR[$app]}=${db_name}" \
    "${APP_DB_USER_VAR[$app]}=${db}" \
    "${APP_DB_PASS_VAR[$app]}=${db_password}" || true
}
