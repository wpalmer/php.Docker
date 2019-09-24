ARG PHP_VERSION=7.1
ARG PHP_VARIANT=fpm
ARG PHP_TAG=${PHP_VERSION}-${PHP_VARIANT}
ARG PHP_IMAGE=php:${PHP_TAG}
ARG PHP_EXT_INSTALL="\
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
"
ARG PHP_EXT_REQUIRE="\
    ${PHP_EXT_INSTALL} \
"
ARG PHP_EXT_BUILD_DEPS="\
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    default-libmysqlclient-dev \
    libpng-dev \
    libxml2-dev \
"

ARG RUN_DEPS="\
    libfreetype6 \
    libjpeg62-turbo \
    libmcrypt4 \
    libpng16-16 \
    msmtp \
"

FROM ${PHP_IMAGE} as php-extensions
ARG PHP_EXT_INSTALL
ARG PHP_EXT_BUILD_DEPS
ARG TIDEWAYS_VERSION=4.1.7

RUN echo ${PHP_EXT_INSTALL} > /php-ext-install
RUN echo ${TIDEWAYS_VERSION} > /tideways-version
RUN if [ `printf '%s\n%s\n' "${PHP_VERSION}" "7.0" | sort -V | sed '1q'` != "7.0" ]; then\
        echo mysql >> /php-ext-install;\
        echo 4.1.6 > /tideways-version;\
    fi
RUN if [ `printf '%s\n%s\n' "${PHP_VERSION}" "7.2" | sort -V | sed '1q'` != "7.2" ]; then echo mcrypt >> /php-ext-install; fi
RUN apt-get update && apt-get install -y ${PHP_EXT_BUILD_DEPS} --no-install-recommends
RUN mkdir -p /usr/include/freetype2/freetype
RUN printf '#!/bin/sh\nexec pkg-config "$@" freetype2\n' > /usr/local/bin/freetype-config
RUN chmod +x /usr/local/bin/freetype-config
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-configure intl
RUN docker-php-ext-install `cat /php-ext-install`
RUN mkdir -p /tmp/xhprof

WORKDIR /tmp/xhprof
RUN curl -s -L https://github.com/tideways/php-profiler-extension/archive/v`cat /tideways-version`.tar.gz | tar -zx --strip-components=1
RUN phpize
RUN ./configure
RUN make
RUN make install


FROM ${PHP_IMAGE}
ARG PHP_EXT_REQUIRE
ARG RUN_DEPS

COPY --from=php-extensions /usr/local/lib/php /usr/local/lib/php
COPY --from=php-extensions /usr/local/include/php /usr/local/include/php
COPY --from=php-extensions /usr/local/etc/php /usr/local/etc/php
COPY --from=php-extensions /php-ext-install /php-ext-install
RUN set -ex \
 && _RUN_DEPS=${RUN_DEPS} \
 && _RUN_DEPS="$_RUN_DEPS `dpkg -l 'libicu*' | awk '{print $2}' | grep '^libicu[0-9][0-9]*' | sort -r | head -n 1`" \
 && apt-get update && apt-get install -y $_RUN_DEPS --no-install-recommends && rm -rf /var/lib/apt/lists/* \
 && php -r '\
    $extensions = $_SERVER["argv"]; array_shift($extensions);\
    foreach ($extensions as $extension) {\
      if (!extension_loaded($extension)) {\
        file_put_contents("php://stderr", "Required extension \"$extension\" not loaded\n");\
        exit(1); \
      }\
    }\
    exit(0);\
  ' `cat /php-ext-install` ${PHP_EXT_REQUIRE} \
 && php -dextension=tideways.so -r 'exit(intval(!extension_loaded("tideways")));' \
 && rm -f /php-ext-install
