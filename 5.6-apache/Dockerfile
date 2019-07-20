FROM php:5.6-apache
ENV PHP_VERSION 5.6
RUN set -xe \
	&& buildDeps=" \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libcurl4-openssl-dev \
		libpng-dev \
		libicu-dev \
		libmcrypt-dev \
		libxml2-dev \
		libxslt-dev \
		libzip-dev \
	" \
	&& runDeps=" \
		msmtp \
	" \
	&& phpExt=" \
		bcmath \
		curl \
		gd \
		intl \
		mbstring \
		pdo \
		pdo_mysql \
		simplexml \
		soap \
		xml \
		xsl \
		zip \
	" \
	&& if [ `printf '%s\n%s\n' "$PHP_VERSION" "7.2" | sort -V | sed '1q'` != "7.2" ]; then phpExt="$phpExt mcrypt"; fi \
	&& apt-get update && apt-get install -y $buildDeps $runDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/include/freetype2/freetype \
	&& printf '#!/bin/sh\nexec pkg-config "$@" freetype2\n' > /usr/local/bin/freetype-config \
	&& chmod +x /usr/local/bin/freetype-config \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install $phpExt \
	&& apt-get purge -y $buildDeps \
	&& cd /usr/bin \
	&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& chmod a+x /usr/bin/composer.phar
