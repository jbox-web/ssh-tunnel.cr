# Ensure that every command in this Makefile
# will run with bash instead of the default sh
SHELL := /usr/bin/env bash

#############
# Constants #
#############

PREFIX      ?= /usr/local
INSTALL_DIR  = $(PREFIX)/bin

SOURCE_FILE = src/ssh-tunnel.cr
OUTPUT_DIR  = bin
OUTPUT_FILE = ssh-tunnel

SPEC_OPTS            =
COMPILE_OPTS_DEV     = --threads 4
COMPILE_OPTS_RELEASE = --threads 4 --release --error-trace

# Use sudo if current user is not root
ifneq ($(UID), 0)
	sudo = sudo
else
	sudo =
endif

ifeq ($(shell tty -s && echo true),true)
	SPEC_OPTS += --verbose
	COMPILE_OPTS_DEV += --progress
	COMPILE_OPTS_RELEASE += --progress
endif

# This is the default task
all: help

.PHONY: all

#####################
# Development tasks #
#####################

setup: ## Setup local environment
	asdf plugin add crystal || true
	asdf plugin add earthly https://github.com/YR-ZR0/asdf-earthly.git || true
	asdf install
	asdf current

build: ## Compile to development binary
	crystal build $(COMPILE_OPTS_DEV) -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(SOURCE_FILE)

deps: ## Install development dependencies
	shards install
	./bin/gi-crystal

clean: ## Cleanup environment
	rm -rf bin/*
	rm -rf lib/

spec: ## Run Crystal spec
	crystal spec $(SPEC_OPTS)

doc: ## Generate Stacker documentation
	rm -rf docs
	crystal doc

ameba: ## Run static code analysis
	bin/ameba

.PHONY: setup build deps clean spec doc ameba


############################
# Docker Development tasks #
############################

docker-image: ## Build local platform Docker image for local development
	docker build . -t ssh-tunnel-dev:latest

docker-images: ## Build multiplatforms Docker images with Earthly
	earthly --ci --output +all-docker-images

.PHONY: docker-image docker-images


#################
# Release tasks #
#################

release: ## Compile to production binary
	crystal build $(COMPILE_OPTS_RELEASE) -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(SOURCE_FILE)
	cd bin; for f in *; do shasum --algorithm 256 $$f > $$f.sha256; done

deps-release: ## Install production dependencies
	shards install --production

install: ## Install ssh-tunnel in $(INSTALL_DIR)
	$(sudo) cp $(OUTPUT_DIR)/$(OUTPUT_FILE) $(INSTALL_DIR)/ssh-tunnel

uninstall: ## Uninstall ssh-tunnel from $(INSTALL_DIR)
	$(sudo) rm -f $(INSTALL_DIR)/ssh-tunnel

release-static: ## Build static binary with Earthly
	earthly --ci --output +all-binaries
	cd packages; for f in *; do shasum --algorithm 256 $$f > $$f.sha256; done

.PHONY: release deps-release install uninstall release-static


#################
# Private tasks #
#################

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help
