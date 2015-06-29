FROM php:5.6-apache

ENV PSVERSION 1.6.0.14


ENV DB_NAME prestashop
ENV DB_PASSWD admin
ENV ADMIN_MAIL demo@prestashop.com
ENV ADMIN_PASSWD prestashop_demo

COPY ./extracts/prestashop_$PSVERSION/prestashop/ /var/www/html/

RUN apt-get update \
	&& apt-get install -y libmcrypt-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libfreetype6-dev \
		mysql-client \
	&& docker-php-ext-install iconv mcrypt pdo pdo_mysql mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN a2enmod rewrite
RUN chown www-data:www-data -R /var/www/html/
RUN mv /var/www/html/install /var/www/html/install-dev
RUN mv /var/www/html/admin /var/www/html/admin-dev

COPY config/php.ini /usr/local/etc/php5
COPY docker_run.sh /tmp/


ENTRYPOINT ["/tmp/docker_run.sh"]
