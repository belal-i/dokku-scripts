create_app() {
  local app="$1"
  dokku apps:create "$app" || true
}

deploy_app() {
  local app="$1"
  dokku git:from-image "$app" "${APP_IMAGE[$app]}"
}
