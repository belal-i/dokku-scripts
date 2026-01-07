dokku apps:create wordpress

# Create database container and link to WordPress
dokku mysql:create  wordpress-db
dokku mysql:link wordpress-db wordpress

# Configure WordPress database connection
# This info also appeared when you created the database.
# We need the Dsn value, for database host, password, username, etc.
dokku mysql:info wordpress-db
