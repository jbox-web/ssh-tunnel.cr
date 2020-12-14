#############
# Constants #
#############

PREFIX      ?= /usr/local
INSTALL_DIR  = $(PREFIX)/bin
SOURCE_FILE  = src/ssh-tunnel.cr
OUTPUT_FILE  = bin/ssh-tunnel

################
# Public tasks #
################

# This is the default task
all: help

ssh-tunnel: ## Compile to development binary
	crystal build --threads 4 -o $(OUTPUT_FILE) $(SOURCE_FILE)

clean: ## Cleanup environment
	rm -rf bin/*
	rm -rf lib/

deps: ## Install development dependencies
	shards install

deps-prod: ## Install production dependencies
	shards install --production

.PHONY: all ssh-tunnel clean deps deps-prod

#################
# Private tasks #
#################

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
