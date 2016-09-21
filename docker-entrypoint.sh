#!/bin/bash


trap exit SIGHUP SIGINT SIGTERM
env | grep -iv PASS | sort

if [ "$1" = 'build' ]; then
    echo "[Run] building static site"

fi

echo "[RUN]: Builtin command not provided [uwsgi]"
echo "[RUN]: $@"

exec "$@"
