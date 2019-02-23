FROM ruby:2.6.1-slim

RUN \
  apt-get update -qq \
  && apt-get install -y --force-yes --no-install-recommends \
    build-essential \
    libpq-dev

WORKDIR /app
