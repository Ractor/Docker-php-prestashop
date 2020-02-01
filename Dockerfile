FROM php:7.1-apache

RUN apt-get update

# PHP EXTENSION: GD (images)
RUN apt-get install -y \
		libfreetype6-dev \
		libpng-dev \
		libjpeg-dev \
	&& docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
		--with-png-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) \
		gd \
	&& apt-get purge -y \
		libfreetype6-dev \
		libpng-dev \
		libjpeg-dev

# PHP EXTENSION: INTL (internationalization)
RUN apt-get install -y \
		libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) \
		intl \
	&& apt-get purge -y \
		libicu-dev

# PHP EXTENSION: OPCACHE (faster cache)
RUN docker-php-ext-install opcache \
	&& docker-php-ext-enable opcache

# PHP EXTENSION: ZIP (zipping and unzipping)
RUN apt-get install -y \
		libzip-dev \
		zlib1g-dev \
                zip \
		unzip \
	&& docker-php-ext-configure zip \
		--with-libzip \
        && docker-php-ext-install -j$(nproc) \
                zip \
        && apt-get purge -y \
		libzip-dev \
		zlib1g-dev \
                zip \
		unzip

# PHP EXTENSION: PDO MYSQL (mysql database access)
RUN docker-php-ext-install pdo_mysql

# PHP mod_rewrite (pretty URLs)
RUN a2enmod rewrite

# Reload apache
RUN service apache2 restart
