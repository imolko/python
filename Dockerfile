FROM python:3

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
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/* \
	gosu nobody true

RUN echo 'deb http://ftp.debian.org/debian stretch-backports main' | tee /etc/apt/sources.list.d/stretch-backports.list \
  && apt-get update \
  && apt-get install -y openjdk-11-jdk \
  && rm -rf /var/lib/apt/lists/*

# Creamos un user dev
RUN groupadd -r dev --gid=9001 && useradd -r -g dev --uid=9001 dev

# Copiamos los entry point
COPY entrypoints /entrypoints
