#!/bin/sh

dir=/docker-entrypoint.d

# Run scripts in $dir
[ -d $dir ] && run-parts $dir

# Init with s6 if CMD is blank
[ -z $1 ] && set -- s6-svscan /etc/s6

# Run puppet command as puppet user
[ "$1" = "puppet" ] && set -- s6-setuidgid puppet "$@"

exec $@
