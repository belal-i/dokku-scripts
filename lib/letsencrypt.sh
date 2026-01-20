enable_ssl() {
  local app="$1"
  local email="$2"
  local testcert="$3"

  dokku letsencrypt:set "$app" email "$email"

  if [[ "$testcert" -eq "$FLAGS_TRUE" ]]; then
    dokku letsencrypt:set "$app" server staging
  fi

  dokku letsencrypt:enable "$app"
}
