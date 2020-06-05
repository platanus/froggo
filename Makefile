PROJECT ?= froggo
DOCKER_COMPOSE_FILE ?= docker-compose.yml

DOCKER_COMPOSE_ARGS ?= -p $(PROJECT) -f $(DOCKER_COMPOSE_FILE)

SHELL := /bin/bash

run: help

BOLD ?= $(shell tput bold)
NORMAL ?= $(shell tput sgr0)

help:
	@echo "Generate a backup in the environment (staging|production) database:"
	@echo "  ${BOLD}make backup-<environment>${NORMAL}"
	@echo ""
	@echo "Copy latest database backup from the environment (staging|production) to local database:"
	@echo "  ${BOLD}make restore-from-<environment>${NORMAL}"
	@echo ""

services-up:
	docker-compose $(DOCKER_COMPOSE_ARGS) up -d

services-stop:
	docker-compose $(DOCKER_COMPOSE_ARGS) stop

services-down:
	docker-compose $(DOCKER_COMPOSE_ARGS) down --volumes

services-port:
	@set -o pipefail; \
	docker-compose port ${SERVICE} ${PORT} 2> /dev/null | cut -d':' -f2 || echo ${PORT}

backup-staging: ROLE=staging
backup-production: ROLE=production
backup-%:
	@echo Capturing $(ROLE)....
	@heroku pg:backups:capture --remote $(ROLE)

restore-from-staging: ROLE=staging
restore-from-production: ROLE=production
restore-from-%:
	$(eval TEMP_FILE=$(shell mktemp))
	@echo Restoring from $(ROLE)....
	@heroku pg:backups:download --remote $(ROLE) --output $(TEMP_FILE)
	@pg_restore --verbose --clean --no-acl --no-owner -h localhost \
		-U postgres -p $(shell make services-port SERVICE=postgresql PORT=5432) -d $(PROJECT)_development $(TEMP_FILE)
