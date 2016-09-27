# This image is used to build and deploy the site using wercker

FROM alpine:edge

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    apk update; apk add bash hugo@testing git openssh-client curl
