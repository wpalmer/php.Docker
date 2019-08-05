FROM php:7.2-fpm
ENV PHP_VERSION 7.2
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
	&& php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& chmod a+x /usr/bin/composer.phar
