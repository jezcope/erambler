# This image is used to build and deploy the site using wercker

FROM python:3.6-stretch

RUN apt-get update && apt-get install -y pandoc node-less locales s3cmd awscli
RUN echo 'en_GB.UTF-8 UTF-8' > /etc/locale.gen && locale-gen
RUN pip install pipenv
COPY Pipfile Pipfile.lock /tmp/build/
WORKDIR /tmp/build
RUN pipenv install --system
RUN aws configure set preview.cloudfront true
