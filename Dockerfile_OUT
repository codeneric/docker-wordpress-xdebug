FROM ubuntu:14.04
MAINTAINER Denis Golovin <denis@codeneric.com>

RUN apt-get update && apt-get -y install realpath software-properties-common && add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get -y --force-yes install php5.6 php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml \
    apache2 libapache2-mod-php5.6 php5.6-mysql mysql-server curl php5.6-gd php5.6-curl \
    wget subversion php5.6-zip

# Install lamp stack plus curl
#RUN apt-get update && \
#    apt-get -y install apache2 libapache2-mod-php5 php5 php5-mysql mysql-server curl php5-gd php5-curl \
#    wget subversion

RUN wget https://phar.phpunit.de/phpunit-5.7.phar && \
    chmod +x phpunit-5.7.phar && \
    mv phpunit-5.7.phar /usr/local/bin/phpunit

RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 258M/g" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 258M/g" /etc/php/5.6/apache2/php.ini

RUN mkdir /debug && \
    touch /debug/php_errors.log && \
    chown www-data:www-data /debug/php_errors.log
RUN sed -i "s/;error_log = php_errors.log/error_log = \/debug\/php_errors.log/g" /etc/php/5.6/apache2/php.ini


ADD apache2.conf /etc/apache2/apache2.conf
# Download WordPress
RUN curl -L "https://wordpress.org/wordpress-latest.tar.gz" > /wordpress.tar.gz && \ 
    rm /var/www/html/index.html && \
    tar -xzf /wordpress.tar.gz -C /var/www/html --strip-components=1 && \
    rm /wordpress.tar.gz

# Download WordPress CLI
RUN curl -L "https://github.com/wp-cli/wp-cli/releases/download/v1.0.0/wp-cli-1.0.0.phar" > /usr/bin/wp && \
    chmod +x /usr/bin/wp

# WordPress configuration
ADD wp-config.php /var/www/html/wp-config.php



# Apache access
RUN chown -R www-data:www-data /var/www/html

# Add configuration script
ADD config_and_start_mysql.sh /config_and_start_mysql.sh
ADD config_apache.sh /config_apache.sh
ADD config_wordpress.sh /config_wordpress.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# MySQL environment variables
ENV MYSQL_WP_USER WordPress
ENV MYSQL_WP_PASSWORD secret

# WordPress environment variables
ENV WP_URL localhost
ENV WP_TITLE WordPress Demo
ENV WP_ADMIN_USER admin_user
ENV WP_ADMIN_PASSWORD secret
ENV WP_ADMIN_EMAIL test@test.com


# Install plugins
RUN apt-get update && \
    apt-get -y --force-yes install php5.6-xdebug

# Add configuration script
ADD config_xdebug.sh /config_xdebug.sh
ADD run_wordpress_xdebug.sh /run_wordpress_xdebug.sh

ADD install-wp-tests.sh /install-wp-tests.sh
ADD wait-for-it.sh /wait-for-it.sh
RUN chmod 755 /*.sh

#RUN ./wait-for-it.sh localhost:3306 -t 99
#RUN bash /install-wp-tests.sh wordpress_test root '' localhost latest

VOLUME /tmp
VOLUME /wordpress_sources

# Xdebug environment variables
ENV XDEBUG_PORT 9000

EXPOSE 80 3306 
CMD ["/run_wordpress_xdebug.sh"]
