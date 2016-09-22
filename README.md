docker-jekyll-gulp
==================

Docker container for building static sites, using Jekyll and Gulp,
including Bootstrap with SASS customisation. This gives you an
environment in which to build Jekyll themes and sites without any
reliance on CDNs.

Your Jekyll site should be available to the container under /app/site/

SASS customising bootstrap should be at /app/sass/style.scss

When the container starts, it will process the SASS customisations
and emit CSS and font resoruces into /app/site/generated/

If you write your Jekyll theme to include the resources from that
path, everything should just work.

