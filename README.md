# Neos Base Image

This is a sample neos base image which can be used for testing, development, staging or production.

[Link to DockerHub](https://hub.docker.com/r/sandstormmedia/neos-base)

It contains:

- php 7.1
- php-fpm
- gd
- PDO driver
- composer
- nginx
- git
- zip

## WARNING

In your entrypoint you need to replace the nginx.conf with the nginx.template. This allows settings values from env variables in the nginx config!
```
envsubst '\$NGINX_HOST \$NGINX_PORT' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf
```