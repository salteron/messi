RAILS_ENV ?= development
TEST_ENV := test
RUN := run --rm
DOCKER_COMPOSE_RUN := docker-compose $(RUN)

default: test

bundle-setup:
	bundle install --jobs 3 --retry 3 --clean --without production

bin-setup:
	bin/setup

setup: bundle-setup bin-setup

test:
	RAILS_ENV=$(TEST_ENV) bundle exec rspec

compose-setup:
	${DOCKER_COMPOSE_RUN} app make setup

compose-web:
	${DOCKER_COMPOSE_RUN} --service-ports web

compose-bash:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" app bash

compose-down:
	docker-compose down

compose-test:
	${DOCKER_COMPOSE_RUN} app make test

compose-build:
	docker-compose build app

compose-rebuild:
	docker-compose build --force-rm --no-cache
