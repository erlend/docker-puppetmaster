#!/bin/sh

dir=/docker-entrypoint.d
fqdn=`hostname -f`

# Run scripts in $dir
[ -d $dir ] && run-parts $dir

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
