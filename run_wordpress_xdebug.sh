#!/bin/sh

./config_xdebug.sh

if [ -d /wordpress_sources ] && [ ! -f /wordpress_sources_moved ]; then

    echo "=> Moving WordPress sources to /wordpress_sources"
    cp -rp /var/www/html/* /wordpress_sources
    touch /wordpress_sources/.htaccess
    rm -r /var/www/html/*
    ln -sf /wordpress_sources/* /var/www/html
    ln -s /wordpress_sources/.htaccess /var/www/html/.htaccess
    chown www-data:www-data /wordpress_sources/.htaccess

    touch /wordpress_sources_moved
fi

./run.sh