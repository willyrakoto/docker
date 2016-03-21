FROM php:5.6-apache

MAINTAINER Willy Rakotoarisoa

ENV PS_VERSION 1.6.1.4

ENV PS_DOMAIN prestashop.local
ENV ADMIN_MAIL demo@prestashop.com
ENV ADMIN_PASSWD prestashop_demo
ENV PS_LANGUAGE fr
ENV PS_COUNTRY fr
ENV PS_INSTALL_AUTO 0
ENV PS_DEV_MODE 0
ENV PS_HOST_MODE 0
ENV PS_HANDLE_DYNAMIC_DOMAIN 0
ENV PS_FOLDER_ADMIN admin
ENV PS_FOLDER_INSTALL install

RUN apt-get update \
	&& apt-get install -y libmcrypt-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libfreetype6-dev \
		libxml2-dev \
		mysql-client \
		wget \
		unzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install iconv mcrypt pdo mysql pdo_mysql mbstring soap gd

# Get PrestaShop
ADD https://www.prestashop.com/ajax/controller.php?method=download&type=releases&file=prestashop_1.6.1.4.zip&language=fr /tmp/prestashop.zip
RUN unzip -q /tmp/prestashop.zip -d /tmp/ && mv /tmp/prestashop/* /var/www/html && rm /tmp/prestashop.zip
COPY config_files/docker_updt_ps_domains.php /var/www/html/

# Apache configuration
RUN a2enmod rewrite
RUN chown www-data:www-data -R /var/www/html/

# PHP configuration
COPY config_files/php.ini /usr/local/etc/php/

EXPOSE 80

VOLUME /var/www/html/modules
VOLUME /var/www/html/themes
VOLUME /var/www/html/override

COPY config_files/docker_run.sh /tmp/
ENTRYPOINT ["/tmp/docker_run.sh"]
