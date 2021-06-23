FROM php:5.6-apache
LABEL authors="Maarten van der Peet"
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN pecl install imagick && docker-php-ext-enable imagick
RUN docker-php-ext-install pdo_mysql mysqli
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN    pear install XML_SVG \
    && pear install Image_Color

COPY config/php.ini  /usr/local/etc/php/php.ini

RUN a2enmod rewrite
RUN apachectl graceful


