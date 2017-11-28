FROM php:5.6-apache
RUN set -xe \
	&& buildDeps=" \
		libcurl4-openssl-dev \
		libpng-dev \
		libicu-dev \
		libmcrypt-dev \
		libxml2-dev \
		libxslt-dev \
	" \
	&& phpExt=" \
		bcmath \
		curl \
		gd \
		intl \
		mbstring \
		mcrypt \
		pdo \
		pdo_mysql \
		simplexml \
		soap \
		xml \
		xsl \
		zip \
	" \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-install $phpExt \
	&& apt-get purge -y $buildDeps
