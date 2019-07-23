# NOTE: this file is executed from the ROOT DIRECTORY of the project, i.e. "../"
FROM php:7.1-fpm-stretch

RUN apt-get update

# Install PDO mysql PHP extension
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Install gd PHP extension
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libcap2-bin \
        git unzip \
        nginx-light gettext-base \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath

# install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php && \
        mv composer.phar /usr/local/bin/composer && \
        composer config --global cache-dir /composer_cache

RUN rm -Rf /usr/local/etc/php-fpm.*
ADD ./memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini
ADD ./php-fpm.conf /usr/local/etc/php-fpm.conf

# nginx config
ADD ./nginx.template.conf /etc/nginx/nginx.template
RUN mkdir -p /var/lib/nginx /usr/local/var/log/ & \
    chown -R www-data /var/lib/nginx /usr/local/var/log/ /etc/nginx/ && \
    setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/nginx

# cleanup & chown
RUN mkdir -p /app/Data/Persistent /app/Configuration/Development/Docker /composer_cache && \
    apt-get clean && \
    chown -R www-data /app /composer_cache

WORKDIR /app

USER www-data
