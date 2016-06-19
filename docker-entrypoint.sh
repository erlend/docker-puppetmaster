#!/bin/sh

# Init with s6 if CMD is blank
[ -z $1 ] && set -- s6-svscan /etc/s6

# Run puppet command as puppet user
[ "$1" = "puppet" ] && set -- s6-setuidgid puppet "$@"

exec $@
