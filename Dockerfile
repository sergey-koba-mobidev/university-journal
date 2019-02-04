FROM ruby:2.6.0

# Pg
RUN apt-get update -qq && apt-get install \
    -y build-essential libpq-dev lsb-release

# Node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs

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