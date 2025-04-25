FROM debian:bullseye

ENV PHP_VERSION 7.4

RUN mkdir -p /run/php

RUN	apt update -y && apt upgrade -y
RUN apt install -y \
	curl \
	wget \
	php${PHP_VERSION} \
	php${PHP_VERSION}-cgi \
	php${PHP_VERSION}-mysql \
	php${PHP_VERSION}-fpm \
	php${PHP_VERSION}-pdo \
	php${PHP_VERSION}-gd \
	php${PHP_VERSION}-cli \
	php${PHP_VERSION}-mbstring \
	php${PHP_VERSION}-redis \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i "s/listen = .*/listen = 0.0.0.0:9000/" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/run_wordpress.sh /
RUN chmod +x /run_wordpress.sh

EXPOSE 9000

CMD [ "/run_wordpress.sh"]