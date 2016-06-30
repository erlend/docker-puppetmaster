#!/bin/sh

ssldir=/var/lib/puppet/ssl
fqdn=`hostname -f`

sed -e "s|\(ssl_certificate *$ssldir/certs/\).*|\1$fqdn.pem;|" \
    -e "s|\(ssl_certificate_key *$ssldir/private_keys/\).*|\1$fqdn.pem;|" \
    -i /etc/nginx.conf
