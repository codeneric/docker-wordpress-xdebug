#!/usr/bin/env bash

#docker rmi -f registry.codeneric.com:5000/wordpress-xdebug
docker build -t codeneric/wordpress-xdebug:5.5 -f Dockerfile_php5 .