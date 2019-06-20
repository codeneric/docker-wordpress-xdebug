#!/usr/bin/env bash


docker rm -f test

docker run \
    --name test \
    -p 8081:80 \
    -e WP_URL="localhost:8081" \
    -e WP_ADMIN_USER=admin \
    -e WP_ADMIN_PASSWORD=admin \
    -d \
    codeneric/wordpress-xdebug