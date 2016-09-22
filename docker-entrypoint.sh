#!/bin/bash

npm_install()
{
    cd /app
    npm install
}

gulp_run()
{
    cd /app
    rm -rf site/generated/
    ./node_modules/.bin/gulp
}


trap exit SIGHUP SIGINT SIGTERM
env | grep -iv PASS | sort

if [ "$1" = 'dev' ]; then
    echo "[Run] building static site"
    npm_install
    gulp_run
    cd /app/site && bundle exec jekyll serve --host=0.0.0.0
    echo "[Run] serving static site"
    while true; do echo goat; sleep 60; done
fi

echo "[RUN]: Builtin command not provided [uwsgi]"
echo "[RUN]: $@"

exec "$@"
