FROM php:5.6-fpm
RUN set -xe \
	&& buildDeps=" \
		libfreetype6-dev \
		libicu-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libmysqlclient-dev \
		libpng12-dev \
		libxml2-dev \
	" \
	&& runDeps=" \
		libfreetype6 \
		libicu52 \
		libjpeg62 \
		libmcrypt4 \
		libmysqlclient18 \
		libpng12-0 \
		libxml2 \
		locales-all \
		msmtp \
	" \
	&& apt-get update && apt-get install -y $buildDeps $runDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& apt-get update \
	&& apt-get install -y  \
	&& docker-php-ext-configure intl \
	&& mkdir -p /usr/include/freetype2/freetype && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) bcmath ctype dom gd iconv intl json mbstring mcrypt mysql mysqli pdo pdo_mysql soap \
	&& rm -rf /usr/include/freetype2/freetype \
	&& ( \
		   mkdir -p /tmp/xhprof \
		&& cd /tmp/xhprof \
		&& curl -s -L https://github.com/tideways/php-profiler-extension/archive/v4.1.2.tar.gz | tar -zx --strip-components=1 \
		&& phpize \
		&& ./configure \
		&& make \
		&& make install \
	) \
	&& rm -rf /tmp/xhprof \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps
