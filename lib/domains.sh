# Global array populated by build_domains
# apex domain and optionally www subdomain.
DOMAINS=()
build_domains() {
  local raw_domain="$1"
  local wwwsubdomain="$2"

  # Populate global DOMAINS array.
  DOMAINS=("$raw_domain")

  if [[ "$wwwsubdomain" -eq "$FLAGS_TRUE" ]]; then
    DOMAINS+=("www.${raw_domain}")
  fi
}
