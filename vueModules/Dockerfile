FROM node:9-alpine

RUN apk add --update \
    python git build-base

ENV WEB_ROOT /web
RUN mkdir $WEB_ROOT
WORKDIR $WEB_ROOT

COPY . /web

RUN npm install
RUN npm install --global  cross-env

EXPOSE 8080
