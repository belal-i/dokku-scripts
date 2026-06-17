log() {
  echo "==> $*"
}

build_domains() {
  local raw_domain="$1"
  local wwwsubdomain="$2"

  # Populate global DOMAINS array.
  DOMAINS=("$raw_domain")

  if [[ "$wwwsubdomain" -eq "$FLAGS_TRUE" ]]; then
    DOMAINS+=("www.${raw_domain}")
  fi
}
