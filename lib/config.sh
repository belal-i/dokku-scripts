DOKKU_SCRUBS_VERSION="0.2.0-dev"

# Defaults
DEFAULT_APP=""
DEFAULT_DOMAIN=""
DEFAULT_DOKKU_TAG="v0.37.5"
DEFAULT_DATABASE="mysql"
DEFAULT_EMAIL=""
DEFAULT_LETSENCRYPT=0

declare -A APP_IMAGE
declare -A APP_DB
declare -A APP_DB_HOST_VAR
declare -A APP_DB_NAME_VAR
declare -A APP_DB_USER_VAR
declare -A APP_DB_PASS_VAR
declare -A APP_VOLUME
declare -A APP_PORT_MAPPING

# Image
# TODO: Support versions as well, defaulting to 'latest'.
APP_IMAGE[wordpress]="wordpress:latest"
APP_IMAGE[joomla]="joomla:latest"
APP_IMAGE[redmine]="redmine:latest"

# Database type
APP_DB[wordpress]="mysql"
APP_DB[joomla]="mysql"
APP_DB[redmine]="mysql"

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

# Volumes (sometimes required)
APP_VOLUME[wordpress]="/var/www/html/wp-content"
APP_VOLUME[joomla]=""
APP_VOLUME[redmine]=""

# Port mappings (sometimes required)
APP_PORT_MAPPING[wordpress]=""
APP_PORT_MAPPING[joomla]=""
APP_PORT_MAPPING[redmine]="3000"
