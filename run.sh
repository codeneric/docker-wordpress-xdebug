#!/bin/sh

./config_and_start_mysql.sh
./config_apache.sh
./config_wordpress.sh
# ./wait-for-it.sh localhost:3306 -t 99
echo "localhost:3306" | xargs wget --retry-connrefused --tries=10 -q --wait=3 --spider
# sleep 25
./install-wp-tests.sh wordpress_test root '' localhost latest

# kill -9 620
# pkill -9 -e -f httpd
echo "=> Apache started..."
/usr/sbin/apache2ctl -D FOREGROUND
