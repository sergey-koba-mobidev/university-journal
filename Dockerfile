FROM ruby:2.6.0-alpine

# Pg and node
RUN apk --update --upgrade add less postgresql-dev git build-base xz-dev libc6-compat linux-headers \
    nodejs-current \
    && rm -rf /var/cache/apk/*

ENV APP_ROOT /app
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

# Bundle
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY vendor /app/vendor
RUN gem update bundler && bundle install --jobs 4 --without development test

EXPOSE 3000

# Copy the rest of Rails source
COPY . /app

WORKDIR $APP_ROOT