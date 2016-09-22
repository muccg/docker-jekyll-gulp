#!/bin/bash

BUILDDIR="/gulpbuild"
TARGET="/app/site/generated"

gulp_run()
{
    cd "$BUILDDIR"
    rm -rf "$TARGET"
    ./node_modules/.bin/gulp
}

trap exit SIGHUP SIGINT SIGTERM
env | grep -iv PASS | sort

if [ "$1" = 'dev' ]; then
    echo "[Run] developing site"
    gulp_run
    cd /app/site && exec bundle exec jekyll serve --host=0.0.0.0
fi

if [ "$1" = 'build' ]; then
    echo "[Run] building production tarball"
    gulp_run
    cd /app/site && bundle exec jekyll build
    cd /app/site/_site && exec tar czvf /build/angelman.tar.gz .
fi

echo "[RUN]: Builtin command not provided [uwsgi]"
echo "[RUN]: $@"

exec "$@"
