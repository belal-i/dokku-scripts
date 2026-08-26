# Array populated by build_domains.
# Contains the app's apex domain and optionally its www subdomain.
DOMAINS=()
build_domains() {
  local raw_domain="$1"
  local wwwsubdomain="$2"

  DOMAINS=("$raw_domain")

  if [[ "$wwwsubdomain" -eq "$FLAGS_TRUE" ]]; then
    DOMAINS+=("www.${raw_domain}")
  fi
}
