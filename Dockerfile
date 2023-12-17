FROM redis:7.2.3

LABEL maintainer="Johan Andersson <Grokzen@gmail.com>, James Zheng <hippozheng@gmail.com>"

# Some Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -yqq \
      net-tools supervisor locales gettext-base wget gcc make g++ build-essential libc6-dev tcl && \
    apt-get clean -yqq

# # Ensure UTF-8 lang and locale
RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen && locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Necessary for gem installs due to SHA1 being weak and old cert being revoked
ENV SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

# RUN gem install redis -v 5.0.8

# This will always build the latest release/commit in the 7.2 branch(by default)
ARG redis_version=7.2

RUN wget -qO redis.tar.gz https://github.com/redis/redis/tarball/${redis_version} \
    && tar xfz redis.tar.gz -C / \
    && mv /redis-* /redis

RUN (cd /redis && make)

RUN mkdir /redis-conf && mkdir /redis-data

RUN cd /usr/local/bin && \
    (rm -f redis-cli || echo "redis-cli not found") && \
    ln -s /redis/src/redis-cli redis-cli

COPY redis-cluster.tmpl /redis-conf/redis-cluster.tmpl
COPY redis.tmpl         /redis-conf/redis.tmpl
COPY sentinel.tmpl      /redis-conf/sentinel.tmpl

# Add startup script
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add script that generates supervisor conf file based on environment variables
COPY generate-supervisor-conf.sh /generate-supervisor-conf.sh

RUN chmod 755 /docker-entrypoint.sh

EXPOSE 7000 7001 7002 7003 7004 7005 7006 7007 5000 5001 5002

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["redis-cluster"]
