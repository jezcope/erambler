# This image is used to build and deploy the site using wercker

FROM debian:sid

RUN apt-get -y update && apt-get -y install hugo git openssh-client curl
