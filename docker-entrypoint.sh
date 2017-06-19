#!/bin/sh

# Save environment variables to /etc/env for later use
rm -f /etc/env
for varname in `env | grep -o "^[A-Z_0-9]*"`; do
  echo "$varname=\"`printenv $varname`\"" >> /etc/env
done

if [ -z $1 ]; then
  run-parts /etc/startup

  set -- s6-svscan /etc/s6
fi

exec $@
