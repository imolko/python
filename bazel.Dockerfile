FROM python:3

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

# Instalamos bazel
RUN set -eux; \
    apt-get update; \
    apt-get install -y curl; \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - ; \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list; \
    apt-get update; \
    apt-get install -y bazel; \
    apt-get full-upgrade -y; \
    rm -rf /var/lib/apt/lists/*

# Copiamos los entry point
COPY entrypoints /entrypoints
