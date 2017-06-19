FROM alpine:3.6

ENV PUPPET_WORKERS 4

ENV PUPPET_VERSION 3.8.7

# Must match puppetdb container version.
ENV PUPPETDB_VERSION 2.3.8

# Dependencies:
#   shadow - puppet
#   util-linux - uuidgen for puppet
#   git - to calculate config_version of puppet repo

RUN build_deps="alpine-sdk ruby-dev" && \
    apk add -U $build_deps \
      ruby \
      git \
      nginx \
      openssl \
      util-linux \
      shadow \
      s6 \
      s6-portable-utils \
      && \
    gem install -N \
      puma \
      syck \
      facter \
      'rack:<2' \
      CFPropertyList \
      puppet:=${PUPPET_VERSION} \
      && \
    apk del $build_deps && \
    rm -r /root/.gem* /var/cache/apk/*

RUN adduser -D puppet

# Put configs and scripts in place
COPY . /

# Fix issue with syck in Ruby >= 2.2
RUN puppet_dir=$(dirname `gem which puppet`)/.. && \
    cp $puppet_dir/ext/rack/config.ru /etc/puppet && \
    sed -e "/\sSyck.module_eval/i\\  require 'syck' if RUBY_VERSION >= '2.2'" \
        -i $puppet_dir/lib/puppet/vendor/safe_yaml/lib/safe_yaml/syck_node_monkeypatch.rb

# Harden the image.
# This must be done *before* we configure volumes.
RUN /usr/sbin/prepare.sh
RUN /usr/sbin/harden.sh

# Do not persist anything in these dirs.
VOLUME ["/var/lib/puppet", "/var/log/puppet"]

# We use dynamic environments.
VOLUME ["/opt/puppet/environments"]

EXPOSE 8140

ENTRYPOINT ["/docker-entrypoint.sh"]
