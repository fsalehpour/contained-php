FROM php:8-cli

###### PHP configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

##### Update packages list
RUN apt-get -y update

##### Install xdebug
RUN pecl install xdebug \
&& docker-php-ext-enable xdebug \
&& echo "xdebug.mode = debug,develop" >> "$PHP_INI_DIR/php.ini" \
&& echo "xdebug.client_host = host.docker.internal" >> "$PHP_INI_DIR/php.ini"

###### Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php --install-dir=/usr/bin --filename=composer \
&& php -r "unlink('composer-setup.php');"

###### Add project directory
RUN mkdir -p /app
WORKDIR /app

CMD ["php", "-S", "0.0.0.0:8080"]