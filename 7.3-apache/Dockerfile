FROM php:7.3-apache
ENV PHP_VERSION 7.3
RUN set -xe \
	&& buildDeps=" \
		libfreetype6-dev \
		libicu-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		default-libmysqlclient-dev \
		libpng-dev \
		libxml2-dev \
		libzip-dev \
	" \
	&& runDeps=" \
		libfreetype6 \
		libjpeg62 \
		libmcrypt4 \
		libpng16-16 \
		libxml2 \
		locales-all \
		msmtp \
	" \
	&& phpExt=" \
		bcmath \
		ctype \
		dom \
		gd \
		iconv \
		intl \
		json \
		mbstring \
		mysqli \
		pdo \
		pdo_mysql \
		soap \
	" \
	&& TIDEWAYS_VERSION=4.1.7 \
	&& if [ `printf '%s\n%s\n' "$PHP_VERSION" "7.0" | sort -V | sed '1q'` != "7.0" ]; then phpExt="$phpExt mysql"; TIDEWAYS_VERSION=4.1.6; fi \
	&& if [ `printf '%s\n%s\n' "$PHP_VERSION" "7.2" | sort -V | sed '1q'` != "7.2" ]; then phpExt="$phpExt mcrypt"; fi \
	&& runDeps="$runDeps `dpkg -l 'libicu*' | awk '{print $2}' | grep '^libicu[0-9][0-9]*' | sort -r | head -n 1`" \
	&& apt-get update && apt-get install -y $buildDeps $runDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/include/freetype2/freetype \
	&& printf '#!/bin/sh\nexec pkg-config "$@" freetype2\n' > /usr/local/bin/freetype-config \
	&& chmod +x /usr/local/bin/freetype-config \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install $phpExt \
	&& ( \
		   mkdir -p /tmp/xhprof \
		&& cd /tmp/xhprof \
		&& curl -s -L https://github.com/tideways/php-profiler-extension/archive/v${TIDEWAYS_VERSION}.tar.gz | tar -zx --strip-components=1 \
		&& phpize \
		&& ./configure \
		&& make \
		&& make install \
	) \
	&& rm -rf /tmp/xhprof \
	&& apt-get purge -y $buildDeps \
	&& rm -f /usr/local/bin/freetype-config
