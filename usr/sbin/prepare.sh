#!/bin/sh
set -x
set -e
#
# Docker build calls this script to prepare the image during build.
#
# NOTE: To build on CircleCI, you must take care to keep the `find`
# command out of the /proc filesystem to avoid errors like:
#
#    find: /proc/tty/driver: Permission denied
#    lxc-start: The container failed to start.
#    lxc-start: Additional information can be obtained by \
#        setting the --logfile and --logpriority options.

# Setup paths for nginx to run with read-only root fs.
mkdir -p /var/tmp/nginx/
mkdir -p /var/log/nginx/
mkdir -p /usr/share/nginx
chown puppet:puppet /var/log/nginx /usr/share/nginx

# Ensure correct permissions for puppet dirs.
mkdir -p /var/lib/puppet/ssl
mkdir -p /var/log/puppet
chown -R puppet:puppet /var/lib/puppet
chmod 0755 /var/lib/puppet
chown -R puppet:puppet /var/log/puppet
chmod 0755 /var/log/puppet
chown -R puppet:puppet /var/lib/puppet/ssl

# nginx buffers client request body here.
mkdir -p /var/tmp/nginx/client_body
chown -R puppet:puppet /var/lib/nginx /var/tmp/nginx

mkdir -p /var/run/puppet || :
chown puppet:puppet /var/run/puppet

chown -R puppet:puppet /etc/puppet
