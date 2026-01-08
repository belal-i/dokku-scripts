setup_db() {
  local app="$1"
  local db="${app}-db"

  # TODO!!!
  dokku mysql:create "$db" --password superinsecure || true
  dokku mysql:link "$db" "$app"

  #local dsn
  #dsn="$(dokku mysql:info "$db" --dsn)"

  dokku config:set "$app" \
    # todo: mysql could also be postgres
    "${APP_DB_HOST_VAR[$app]}=dokku-mysql-${app}-db" \
    "${APP_DB_NAME_VAR[$app]}=${app}_db" \
    # todo: mysql could also be postgres
    "${APP_DB_USER_VAR[$app]}=mysql" \
    # TODO!!!
    "${APP_DB_PASS_VAR[$app]}=superinsecure"
}
