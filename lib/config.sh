DOKKU_SCRUBS_VERSION="0.3.0-dev"

# Defaults
DEFAULT_APP_VERSION="latest"
DEFAULT_DOKKU_TAG="v0.37.9"
DEFAULT_LETSENCRYPT=0

BASE_STORAGE="/var/lib/dokku/data/storage"

declare -A APP_IMAGE
declare -A APP_DB
declare -A APP_DB_HOST_VAR
declare -A APP_DB_NAME_VAR
declare -A APP_DB_USER_VAR
declare -A APP_DB_PASS_VAR
declare -A APP_PORT_MAPPING
declare -A APP_VOLUMES_wordpress
declare -A APP_VOLUMES_joomla
declare -A APP_VOLUMES_redmine
declare -A APP_VOLUMES_dolibarr
declare -A APP_VOLUMES_erpnext

APP_IMAGE[wordpress]="wordpress"
APP_IMAGE[joomla]="joomla"
APP_IMAGE[redmine]="redmine"
APP_IMAGE[dolibarr]="dolibarr/dolibarr"
APP_IMAGE[erpnext]="frappe/erpnext"

# Database type
APP_DB[wordpress]="mysql"
APP_DB[joomla]="mysql"
APP_DB[redmine]="mysql"
APP_DB[dolibarr]="mysql"
APP_DB[erpnext]="mysql"

# Env var mappings
APP_DB_HOST_VAR[wordpress]="WORDPRESS_DB_HOST"
APP_DB_NAME_VAR[wordpress]="WORDPRESS_DB_NAME"
APP_DB_USER_VAR[wordpress]="WORDPRESS_DB_USER"
APP_DB_PASS_VAR[wordpress]="WORDPRESS_DB_PASSWORD"

APP_DB_HOST_VAR[joomla]="JOOMLA_DB_HOST"
APP_DB_NAME_VAR[joomla]="JOOMLA_DB_NAME"
APP_DB_USER_VAR[joomla]="JOOMLA_DB_USER"
APP_DB_PASS_VAR[joomla]="JOOMLA_DB_PASSWORD"

APP_DB_HOST_VAR[redmine]="REDMINE_DB_MYSQL"
APP_DB_NAME_VAR[redmine]="REDMINE_DB_DATABASE"
APP_DB_USER_VAR[redmine]="REDMINE_DB_USERNAME"
APP_DB_PASS_VAR[redmine]="REDMINE_DB_PASSWORD"

APP_DB_HOST_VAR[dolibarr]="DOLI_DB_HOST"
APP_DB_NAME_VAR[dolibarr]="DOLI_DB_NAME"
APP_DB_USER_VAR[dolibarr]="DOLI_DB_USER"
APP_DB_PASS_VAR[dolibarr]="DOLI_DB_PASSWORD"

APP_DB_HOST_VAR[erpnext]="DOLI_DB_HOST"
# Didn't find it in their docs.
APP_DB_NAME_VAR[erpnext]="DB_NAME"
# Didn't find it in their docs. They use root - see below
APP_DB_USER_VAR[erpnext]="DB_USER"
# They only use the root password apparently...
APP_DB_PASS_VAR[erpnext]="MYSQL_ROOT_PASSWORD"

# Volumes (sometimes required)
APP_VOLUMES_wordpress=(
  ["$BASE_STORAGE/wordpress"]="/var/www/html/wp-content"
)
APP_VOLUMES_joomla=()
APP_VOLUMES_redmine=()
APP_VOLUMES_dolibarr=(
  ["$BASE_STORAGE/dolibarr/documents"]="/var/www/documents"
  ["$BASE_STORAGE/dolibarr/custom"]="/var/www/html/custom"
)
# TODO: For ERPNext, have to do something like this:
# chown -R 1000:1000 /var/lib/dokku/data/storage/erpnext/  2>/dev/null || true
APP_VOLUMES_erpnext=(
  ["$BASE_STORAGE/erpnext/sites"]="/home/frappe/frappe-bench/sites"
  ["$BASE_STORAGE/erpnext/logs"]="/home/frappe/frappe-bench/logs"
)

# Port mappings (sometimes required)
APP_PORT_MAPPING[wordpress]=""
APP_PORT_MAPPING[joomla]=""
APP_PORT_MAPPING[redmine]="3000"
APP_PORT_MAPPING[dolibarr]=""
APP_PORT_MAPPING[erpnext]="8000"
# "Nuclear option":
# dokku config:set erpnext DOKKU_PROXY_PORT_MAP="http:80:8000"
# dokku ps:restart erpnext
