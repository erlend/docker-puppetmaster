FROM alpine:3.4

ENV PUPPET_WORKERS 128

ENV PUPPET_VERSION 3.8.7

# Must match puppetdb container version.
ENV PUPPETDB_VERSION 2.3.8

# Dependencies:
#   shadow - puppet
#   util-linux - uuidgen for puppet
#   ruby < 2.2 (from alpine 3.1) to avoid syck errors in puppet 3.x
#   git - to calculate config_version of puppet repo
#
# https://tickets.puppetlabs.com/browse/PUP-3796 (syck error in ruby 2.2)
#
# http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Holding_a_specific_package_back
#
RUN apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/v3.1/main \
      'ruby<2.2' \
      ruby-unicorn \
    && \
    apk add --no-cache \
      ca-certificates \
      git \
      nginx \
      'openssl>=1.0.2h-r0' \
      s6 \
      s6-portable-utils \
      util-linux \
    && \
    apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/community \
      shadow \
    && \
    :

# Install gems compatible with ruby < 2.2
RUN gem install -N \
      facter \
      'rack:<2' \
      CFPropertyList \
      puppet:=${PUPPET_VERSION} \
    && \
    rm -fr /root/.gem*

RUN adduser -D puppet

# Put configs and scripts in place.
COPY . /

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
