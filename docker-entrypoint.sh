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

    cd /app/site
    exec bundle exec jekyll serve --host=0.0.0.0
fi

if [ "$1" = 'releasetarball' ]; then
    echo "[Run] building production tarball"

    gulp_run

    cd /app/site
    bundle exec jekyll build

    cd /app/site/_site
    exec tar czf /build/${TARBALL_NAME}-${TARBALL_GIT_TAG}.tar.gz .
fi

echo "[RUN]: Builtin command not provided [dev|releasetarball]"
echo "[RUN]: $@"

exec "$@"
