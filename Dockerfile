# This image is used to build and deploy the site using wercker

FROM debian:sid

RUN apt-get -y update && apt-get -y install wget git openssh-client curl
RUN URL='https://github.com/spf13/hugo/releases/download/v0.19/hugo_0.19-64bit.deb'; FILE=`mktemp`; wget "$URL" -qO $FILE && dpkg -i $FILE; rm $FILE
