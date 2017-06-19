#!/bin/sh

sv_stop() {
  for daemon in `ls /etc/daemons/*`; do
    /sbin/sv stop $daemon
  done
}

trap "sv_stop; exit" SIGTERM

runsvdir /etc/daemons
