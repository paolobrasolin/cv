FROM ruby:2.7.8-alpine as ruby
RUN apk --update --no-cache add build-base
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

FROM node:lts-alpine as node
RUN apk --update --no-cache add build-base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install

