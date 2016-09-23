FROM buildpack-deps:jessie-curl
MAINTAINER https://github.com/muccg/

ARG ARG_GIT_TAG=next_release

ENV GIT_TAG $ARG_GIT_TAG
ENV PROJECT_NAME jekyll-gulp
ENV NODE_MODULES /npm/node_modules

RUN env | sort

RUN addgroup --gid 1000 jekyll \
    && adduser --disabled-password --home /data --no-create-home --system -q --uid 1000 --ingroup jekyll jekyll \
    && mkdir /data \
    && chown jekyll:jekyll /data

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  libgeos-c1 \
  libjpeg-dev \
  libpcre3 \
  libpcre3-dev \
  libpng12-dev \
  libpq5 \
  libpq-dev \
  libssl-dev \
  libyaml-dev \
  libxml2 \
  libxml2-dev \
  libxslt1-dev \
  nodejs \
  nodejs-legacy \
  npm \
  python-pil \
  ruby \
  ruby-dev \
  zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN yes | gem update --no-document -- --use-system-libraries
RUN yes | gem update --system --no-document -- --use-system-libraries
RUN yes | gem install jekyll
RUN yes | gem install bundler
RUN yes | gem install minima

# Cache npm deps into /npm
COPY package.json /npm/package.json
RUN cd /npm && npm install --ignore-scripts
    
# Cache bower deps into /bower
COPY bower.json /bower/bower.json
RUN cd /bower && /npm/node_modules/.bin/bower install --allow-root --config.interactive=false

COPY gulpfile.js /gulpbuild/gulpfile.js
COPY package.json /gulpbuild/package.json
RUN cd /gulpbuild && npm install

RUN chown -R jekyll /gulpbuild/

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/app", "/data", "/gulpbuild"]

# Drop privileges, set home for jekyll
USER jekyll
ENV HOME /data
WORKDIR /data

EXPOSE 4000

# entrypoint shell script that by default starts uwsgi
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dev"]
