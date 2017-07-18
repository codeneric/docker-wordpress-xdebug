#!/bin/sh

./config_and_start_mysql.sh
./config_apache.sh
./config_wordpress.sh
#./wait-for-it.sh localhost:3306 -t 99
./install-wp-tests.sh wordpress_test root '' localhost latest

echo "=> Apache started..."
/usr/sbin/apache2ctl -D FOREGROUND
