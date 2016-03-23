FROM php:5.6-apache

MAINTAINER Willy Rakotoarisoa

# Set the labels that are used for Openshift to describe the builder image.
LABEL io.k8s.description="Apache with php5.6 based on Debian" \
    io.k8s.display-name="PHP5.6-apache-debian" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,webserver,html,php" \
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble, save-artifacts)
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

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

# Apache configuration
# Expose 8080 because 80 is allowed only for root and change log files
RUN a2enmod rewrite
RUN chmod -R a+rwx /var/www/html/
RUN sed -e 's/Listen 80/Listen 8080/' -i /etc/apache2/apache2.conf /etc/apache2/ports.conf \
 && sed -i 's/ErrorLog .*/ErrorLog \/var\/log\/apache2\/error.log/' /etc/apache2/apache2.conf \
 && sed -i 's/CustomLog .*/CustomLog \/var\/log\/apache2\/custom.log combined/' /etc/apache2/apache2.conf \
 && sed -i 's/LogLevel .*/LogLevel info/' /etc/apache2/apache2.conf \
 && touch /var\/log\/apache2\/error.log \
 && touch \/var\/log\/apache2\/custom.log \
 && chmod -R a+rwx /var/log/apache2 \
 && chmod -R a+rwx /var/lock/apache2 \
 && chmod -R a+rwx /var/run/apache2

# PHP configuration
COPY config_files/php.ini /usr/local/etc/php/

# Expose 8080 because 80 is allowed only for root
EXPOSE 8080

#User
USER 1001

# Copy the S2I scripts to /usr/libexec/s2i since we set the label that way
COPY  ["run", "assemble", "save-artifacts", "usage", "/usr/libexec/s2i/"]

# Modify the usage script in your application dir to inform the user how to run
# this image.
CMD ["/usr/libexec/s2i/usage"]