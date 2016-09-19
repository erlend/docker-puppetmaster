#!/bin/sh

dir=/docker-entrypoint.d
fqdn=`hostname -f`

# Configure NGINX
sed -e "s|\(ssl_certificate *$ssldir/certs/\).*|\1$fqdn.pem;|" \
    -e "s|\(ssl_certificate_key *$ssldir/private_keys/\).*|\1$fqdn.pem;|" \
    -i /etc/nginx.conf

# Configure Unicorn
sed -e "s|\(worker_processes\).*|\1 $PUPPET_WORKERS|" \
    -i /etc/puppet/unicorn.conf

if [ -z $1 ]; then
  if [ -f /var/lib/puppet/ssl/certs/ca.pem ]; then
    # Start normally as CA seems to be configured
    set -- s6-svscan /etc/s6
  else
    # Run the slower puppet master to autogenerate missing certificates
    set -- puppet master --verbose --no-daemonize
  fi
fi

exec $@
