FROM php:7.1-apache

# RUN apt update && apt install -y apt-transport-https lsb-release
RUN apt update && apt install -y apt-transport-https
RUN curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
# RUN echo 'deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN echo 'deb https://packages.sury.org/php/ jessie main' > /etc/apt/sources.list.d/php.list

# RUN apt-get update && apt-get install -y php-intl php-mysql php-xmlrpc php-gd
# RUN apt update && apt install -y php7.1-intl php7.1-mysql php7.1-xmlrpc php7.1-gd

##
# Install PHP 7.1 Extensions specific to Moodle
##
RUN set -xe \
        && installDeps=" \
                         libicu-dev \
                         libpng-dev \
                         libxml2-dev \
                         zlib1g-dev \
                         libldap2-dev \
                       " \
        && apt-get update && apt-get install -y $installDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
        && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/ \
        && docker-php-ext-install -j$(nproc) gd intl mysqli opcache soap xmlrpc zip ldap \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $installDeps
