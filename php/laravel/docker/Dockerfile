FROM composer:2.1.5 AS composer

FROM php:8.0-fpm-alpine as php_builds

RUN apk --update add --no-cache \
  autoconf \
  postgresql-dev \
  libpng-dev \
  freetype-dev \
  libjpeg-turbo-dev \
  libzip-dev \
  zip \
  && docker-php-ext-install opcache pdo_pgsql pgsql gd zip

FROM php:8.0-fpm-alpine

WORKDIR /app
COPY . /app/

ENV PATH=/root/.composer/vendor/bin:/usr/local/bin/pear:$PATH
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PHP_EXT_DIR=/usr/local/lib/php/extensions/no-debug-non-zts-20200930

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=php_builds $PHP_EXT_DIR/opcache.so $PHP_EXT_DIR/opcache.so
COPY --from=php_builds $PHP_EXT_DIR/pdo_pgsql.so $PHP_EXT_DIR/pdo_pgsql.so
COPY --from=php_builds $PHP_EXT_DIR/pgsql.so $PHP_EXT_DIR/pgsql.so
COPY --from=php_builds $PHP_EXT_DIR/gd.so $PHP_EXT_DIR/gd.so
COPY --from=php_builds $PHP_EXT_DIR/zip.so $PHP_EXT_DIR/zip.so

RUN apk --update add --no-cache \
  bash \
  curl \
  git \
  libpng-dev \
  freetype-dev \
  libjpeg-turbo-dev \
  libzip-dev \
  zip \
  nodejs \
  npm \
  postgresql-client \
  python2 \
  rsync \
  nano \
  && mkdir /usr/share/man/man1 /usr/share/man/man7 \
  && docker-php-ext-enable opcache pdo_pgsql pgsql gd zip \
  # Add APM and Profiling for PHP apps
  && apk add libexecinfo \
  && mkdir -p /etc/datadog \
  # 0.69.0 is the latest version of the tracer as of 20220202 and is the first version to include
  # profililng support (in public beta).
  && curl -L https://github.com/DataDog/dd-trace-php/releases/download/0.69.0/datadog-setup.php -o /etc/datadog/datadog-setup.php \
  # For the purposes of this example, the php-fpm install is for the app
  && php '/etc/datadog/datadog-setup.php' '--enable-profiling' '--php-bin=php-fpm' \
  # and the php install is for the demo-script. In practice only one should be necessary
  && php '/etc/datadog/datadog-setup.php' '--enable-profiling' '--php-bin=php'
