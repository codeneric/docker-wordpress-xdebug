FROM php:7.1-apache
# FROM php:5.6.29-apache
RUN docker-php-ext-install mysqli
RUN pecl install xdebug-2.7.2
# RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# RUN apt-get update -y && apt-get install -y sendmail libpng-dev
RUN apt-get update -y && apt-get install -y sendmail libpng-dev libjpeg-dev

# RUN apt-get update && \
#     apt-get install -y \
#     zlib1g-dev 

# RUN docker-php-ext-install mbstring

RUN docker-php-ext-install zip

# RUN docker-php-ext-install gd

RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd

RUN echo "upload_max_filesize = 128M" >> /usr/local/etc/php/php.ini
RUN echo "post_max_size = 128M" >> /usr/local/etc/php/php.ini

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/php.ini


RUN apt-get update && apt-get -y install mysql-server nano
RUN a2enmod rewrite
# RUN service mysql start
RUN service mysql start && mysql -uroot -p -e "GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost' IDENTIFIED BY 'password';" && mysql -u username -ppassword -e "CREATE DATABASE wordpress;"



# Download WordPress
RUN curl -L "https://wordpress.org/wordpress-latest.tar.gz" > /wordpress.tar.gz
RUN tar -xzf /wordpress.tar.gz -C /var/www/html --strip-components=1 && \
    rm /wordpress.tar.gz



# Download WordPress CLI
RUN curl -L "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar" > /usr/bin/wp && \
    chmod +x /usr/bin/wp

# RUN service mysql start && cd /var/www/html && \
# wp config create --dbname=wordpress --dbuser=username --dbpass=password --dbhost=127.0.0.1  --allow-root && \
# RUN cd /var/www/html && wp config set WP_DEBUG true --raw --allow-root

# WordPress configuration
# ADD wp-config.php /var/www/html/wp-config.php
COPY start-apache-and-mysql.sh /start-apache-and-mysql.sh
RUN chmod +x /start-apache-and-mysql.sh 

RUN chmod -R 777 /var/www/html
RUN chown -R www-data:www-data /var/www/html
# EXPOSE 80 3306 9000
EXPOSE 22

# ENTRYPOINT ["/start-apache-and-mysql.sh"]
CMD [ "apache2-foreground" ]
ENTRYPOINT ["/start-apache-and-mysql.sh"]