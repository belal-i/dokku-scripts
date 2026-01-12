enable_ssl() {
  local app="$1"
  local email="$2"

  dokku letsencrypt:set "$app" email "$email"
  dokku letsencrypt:enable "$app"
}
