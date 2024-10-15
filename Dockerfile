FROM ubuntu:22.04

RUN apt-get update -y

RUN apt update -y && apt install -y lua5.1 liblua5.1-dev luarocks build-essential wget git zip unzip
RUN git config --global url.https://github.com/.insteadOf git://github.com/

WORKDIR /home/luacov-sonarcloud

RUN chmod -R a+rw /home/luacov-sonarcloud
