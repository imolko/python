FROM python:3-alpine

#ENV GOSU_VERSION 1.12
#RUN set -x \
#  && curl -sSLo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
#  && curl -sSLo /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
#  && export GNUPGHOME="$(mktemp -d)" \
#  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
#  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
#  && chmod +x /usr/local/bin/gosu \
#  && gosu nobody true

# Instrucciones de instalaccion en https://github.com/tianon/gosu/blob/master/INSTALL.md

COPY /gosu/* /opt/gosu/
RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
		dpkg \
		gnupg \
		openssl \
	&& /opt/gosu/gosu.download.sh \
	&& /opt/gosu/gosu.install.sh \
    && apk del .gosu-deps \
    && rm /tmp/* -rf

RUN set -ex && gosu nobody true

RUN set -ex \
	&&  apk add --no-cache \
		bash \
		openjdk11-jdk

# Creamos un user dev
RUN addgroup -S -g 9001 dev && adduser -S -G dev -u 9001 dev && id dev

RUN apk --no-cache add shadow curl

# Copiamos los entry point
COPY entrypoints /entrypoints
