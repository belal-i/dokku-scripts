DOKKU_SCRUBS_VERSION="0.6.0-dev"

DOKKU_SCRUBS_ROOT="/usr/local"
DOKKU_SCRUBS_BIN="$DOKKU_SCRUBS_ROOT/bin/dokku-scrubs"
DOKKU_SCRUBS_LIB="$DOKKU_SCRUBS_ROOT/lib/dokku-scrubs"
DOKKU_SCRUBS_ETC="$DOKKU_SCRUBS_ROOT/etc"

# Defaults
DEFAULT_APP_VERSION="latest"
DEFAULT_DOKKU_TAG="v0.38.25"
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
declare -A APP_VOLUMES_drupal
declare -A APP_VOLUMES_redmine
declare -A APP_VOLUMES_dolibarr

APP_IMAGE[wordpress]="wordpress"
APP_IMAGE[joomla]="joomla"
APP_IMAGE[drupal]="drupal"
APP_IMAGE[redmine]="redmine"
APP_IMAGE[dolibarr]="dolibarr/dolibarr"

# Database type
APP_DB[wordpress]="mysql"
APP_DB[joomla]="mysql"
APP_DB[drupal]="mysql"
APP_DB[redmine]="mysql"
APP_DB[dolibarr]="mysql"

# Env var mappings
APP_DB_HOST_VAR[wordpress]="WORDPRESS_DB_HOST"
APP_DB_NAME_VAR[wordpress]="WORDPRESS_DB_NAME"
APP_DB_USER_VAR[wordpress]="WORDPRESS_DB_USER"
APP_DB_PASS_VAR[wordpress]="WORDPRESS_DB_PASSWORD"

APP_DB_HOST_VAR[joomla]="JOOMLA_DB_HOST"
APP_DB_NAME_VAR[joomla]="JOOMLA_DB_NAME"
APP_DB_USER_VAR[joomla]="JOOMLA_DB_USER"
APP_DB_PASS_VAR[joomla]="JOOMLA_DB_PASSWORD"

APP_DB_HOST_VAR[drupal]="MYSQL_HOST"
APP_DB_NAME_VAR[drupal]="MYSQL_DATABASE"
APP_DB_USER_VAR[drupal]="MYSQL_USER"
APP_DB_PASS_VAR[drupal]="MYSQL_PASSWORD"

APP_DB_HOST_VAR[redmine]="REDMINE_DB_MYSQL"
APP_DB_NAME_VAR[redmine]="REDMINE_DB_DATABASE"
APP_DB_USER_VAR[redmine]="REDMINE_DB_USERNAME"
APP_DB_PASS_VAR[redmine]="REDMINE_DB_PASSWORD"

APP_DB_HOST_VAR[dolibarr]="DOLI_DB_HOST"
APP_DB_NAME_VAR[dolibarr]="DOLI_DB_NAME"
APP_DB_USER_VAR[dolibarr]="DOLI_DB_USER"
APP_DB_PASS_VAR[dolibarr]="DOLI_DB_PASSWORD"

# Volumes (sometimes required)
APP_VOLUMES_wordpress=(
  ["$BASE_STORAGE/wordpress"]="/var/www/html/wp-content"
)
APP_VOLUMES_joomla=()
# TODO
APP_VOLUMES_drupal=(
  ["$BASE_STORAGE/drupal/modules"]="/var/www/html/modules"
  ["$BASE_STORAGE/drupal/profiles"]="/var/www/html/profiles"
  ["$BASE_STORAGE/drupal/sites"]="/var/www/html/sites"
  ["$BASE_STORAGE/drupal/themes"]="/var/www/html/themes"

)
APP_VOLUMES_redmine=()
APP_VOLUMES_dolibarr=(
  ["$BASE_STORAGE/dolibarr/documents"]="/var/www/documents"
  ["$BASE_STORAGE/dolibarr/custom"]="/var/www/html/custom"
)

# Port mappings (sometimes required)
APP_PORT_MAPPING[wordpress]=""
APP_PORT_MAPPING[joomla]=""
APP_PORT_MAPPING[drupal]=""
APP_PORT_MAPPING[redmine]="3000"
APP_PORT_MAPPING[dolibarr]=""
