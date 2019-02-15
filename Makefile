# --------------------------------------------------------------------
# Copyright (c) 2019 LINKIT, The Netherlands. All Rights Reserved.
# Author(s): Anthony Potappel
# 
# This software may be modified and distributed under the terms of the
# MIT license. See the LICENSE file for details.
# --------------------------------------------------------------------

# If you see pwd_unknown showing up, this is why. Re-calibrate your system.
PWD ?= pwd_unknown

# project_name defaults to name of the current directory.
# should not be a need to change this if you follow GitOps procedures.
PROJECT_NAME = $(notdir $(PWD))

# Note. If you change this, you also need to update docker-compose.yml.
# only useful in a setting with multiple services/ makefiles.
SERVICE_TARGET := main

# if vars not set specifially: try default to environment, else fixed value.
# USER retrieved from env, UID from shell.
# Strip to ensure spaces are removed in future editorial mistakes.
# Tested to work consistently on popular Linux flavors and Mac.
HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),4000))
THIS_FILE := $(lastword $(MAKEFILE_LIST))
RUN_ARGUMENTS ?= $(run)

# export such that its passed to shell functions for Docker to pick up.
export PROJECT_NAME
export HOST_USER
export HOST_UID

.PHONY: help build rebuild test clean run

# suppress makes own output
#.SILENT:

# run should be the first target. So instead of: make run run="whoami", we can type: make run="whoami".
# more examples: make run c="whoami && env", make run c="echo hello container space".
# leave the double quotes to prevent commands overflowing in makefile (things like && would break)
# special chars: '',"",|,&&,||,*,^,[], should all work. Except "$" and "`", if someone knows how, let me know!).
# escaping (\) does work on most chars, except double quotes (if someone knows how, let me know!)
# i.e. works on most cases. For everything else perhaps more useful to upload a script and execute that.
# to enter a container, just fill in "/bin/sh" or "/bin/bash" (assuming either shell is available).
run:
ifeq ($(RUN_ARGUMENTS),)
	@echo "no runcommand (e.g. make run='whoami') given."
else
	docker-compose run --rm $(SERVICE_TARGET) sh -c "$(RUN_ARGUMENTS)"
endif

# Regular Makefile part for buildpypi itself
help:
	@echo ''
	@echo 'Usage: make [TARGET] [RUN_ARGUMENTS]'
	@echo 'Targets:'
	@echo '  build    build docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  rebuild  rebuild docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  test     test docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  clean    remove docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  run      run docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo ''
	@echo 'Run arguments. No need to pass TARGET. Format as run="{YOUR ARGUMENTS}".'
	@echo 'Example: make run="whoami"'

rebuild:
	docker-compose build --no-cache $(SERVICE_TARGET)

build:
	docker-compose build $(SERVICE_TARGET)

test:
	docker-compose run --rm $(SERVICE_TARGET) sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success

clean:
	@docker-compose down --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" already removed.'
