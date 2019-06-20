#!/bin/bash
set -e

# if [ -z "$WP_URL" ]
# then
#     echo "--env WP_URL has to be set"
#     exit 1
# fi

# if [ -z "$WP_URL" ]
# then
#     echo "--env WP_URL has to be set"
#     exit 1
# fi
if [ -z "$XDEBUG_PORT" ]; then
	XDEBUG_PORT=9000
fi

if [ -z "$WP_URL" ]; then
	echo "Environment variable WP_URL was not passed, but is required!"
    exit 1;
fi

echo "xdebug.remote_port=$XDEBUG_PORT" >> /usr/local/etc/php/php.ini

service mysql start
# service apache2 start
# apache2-foreground

if [ ! -f "wp-config.php" ]; then
    wp config create \
        --dbname=wordpress \
        --dbuser=username \
        --dbpass=password \
        --dbhost=127.0.0.1  \
        --allow-root

    wp core install \
        --url=$WP_URL \
        --title="Codeneric Dev" \
        --admin_user=admin \
        --admin_password=admin \
        --admin_email=dev@codeneric.com \
        --skip-email \
        --allow-root

    wp config set WP_DEBUG true \
        --raw \
        --allow-root
	
fi

# wp language core install de_DE --allow-root

exec "$@" 
