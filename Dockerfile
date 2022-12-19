FROM php:5.6-apache
LABEL authors="Maarten van der Peet"
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN pecl install imagick && docker-php-ext-enable imagick
# RUN apt-get install -y libmcrypt-dev

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \

    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/  \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get update && apt-get install -y libxslt-dev
RUN docker-php-ext-install xsl mbstring xmlrpc  wddx dom zip && \
    docker-php-ext-install pdo_mysql mysqli mysql  

RUN   pear install PEAR \
    && pear install DB \

    && pear install MDB2 \
    && pear install pear/MDB2#mysqli \
    && pear install pear/MDB2#mysql \

    && pear install DB_Pager \
    && pear install XML_SVG \
    && pear install Image_Color 


COPY config/php.ini  /usr/local/etc/php/php.ini
# when this image will be used behind an external proxy, add the proxy IP to remoteip.conf
# otherwise the IP's of end users won't show up in the container logs
COPY config/remoteip.conf /etc/apache2/mods-available/remoteip.conf
COPY font/luxisb.ttf  /usr/X11/lib/X11/fonts/TTF/luxisb.ttf
COPY font/luxisr.ttf  /usr/X11/lib/X11/fonts/TTF/luxisr.ttf


RUN a2enmod rewrite && a2enmod remoteip
RUN apachectl graceful
