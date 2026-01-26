# shlib - Makefile
#
# Usage:
#   make help     - Show available targets
#   make check    - Run all checks (lint + test)
#   make format   - Format all shell scripts
#

# Shell configuration
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Tools
SHELLCHECK := shellcheck
SHFMT := shfmt
BATS := bats

# Tool options
SHELLCHECK_OPTS := -s bash
SHFMT_OPTS := -i 4 -ci -bn

# Files
SHELL_FILES := shlib.sh
TEST_FILES := $(wildcard tests/*.bats)
EXAMPLE_FILES := $(wildcard examples/*.sh)
ALL_SHELL_FILES := $(SHELL_FILES) $(EXAMPLE_FILES) $(TEST_FILES)

# Docker
DOCKER_IMAGE := shlib
DOCKER := docker

# Colors for output
BOLD := $(shell tput bold 2>/dev/null || echo '')
GREEN := $(shell tput setaf 2 2>/dev/null || echo '')
YELLOW := $(shell tput setaf 3 2>/dev/null || echo '')
RESET := $(shell tput sgr0 2>/dev/null || echo '')

# Default target
.DEFAULT_GOAL := help

# Phony targets
.PHONY: help check lint shellcheck format format-check test \
        docker-build docker-test docker-shell clean

## help: Show this help message
help:
	@echo '$(BOLD)shlib$(RESET) - Shell library of reusable Bash functions'
	@echo ''
	@echo '$(BOLD)Usage:$(RESET)'
	@echo '  make $(GREEN)<target>$(RESET)'
	@echo ''
	@echo '$(BOLD)Targets:$(RESET)'
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':' | sed 's/^/  /'

## all: Run all linters and formatters
all: check docker-build

## check: Run all checks (lint + test)
check: lint format-check test
	@echo '$(GREEN)All checks passed$(RESET)'

## lint: Run shellcheck on all shell files
lint: shellcheck

## shellcheck: Run shellcheck static analysis
shellcheck:
	@echo '$(BOLD)Running shellcheck...$(RESET)'
	@$(SHELLCHECK) $(SHELLCHECK_OPTS) $(ALL_SHELL_FILES)
	@echo '$(GREEN)shellcheck passed$(RESET)'

## format: Format all shell scripts with shfmt
format:
	@echo '$(BOLD)Formatting shell scripts...$(RESET)'
	@$(SHFMT) $(SHFMT_OPTS) -w $(ALL_SHELL_FILES)
	@echo '$(GREEN)Formatting complete$(RESET)'

## format-check: Check if files are formatted (no changes)
format-check:
	@echo '$(BOLD)Checking formatting...$(RESET)'
	@$(SHFMT) $(SHFMT_OPTS) -d $(ALL_SHELL_FILES)
	@echo '$(GREEN)Formatting check passed$(RESET)'

## test: Run all bats tests
test:
	@echo '$(BOLD)Running tests...$(RESET)'
	@$(BATS) tests/
	@echo '$(GREEN)All tests passed$(RESET)'

## docker-build: Build the Docker development image
docker-build:
	@echo '$(BOLD)Building Docker image...$(RESET)'
	@$(DOCKER) build -t $(DOCKER_IMAGE) .
	@echo '$(GREEN)Docker image built: $(DOCKER_IMAGE)$(RESET)'

## docker-test: Run tests inside Docker container
docker-test: docker-build
	@echo '$(BOLD)Running tests in Docker...$(RESET)'
	@$(DOCKER) run --rm -v "$(PWD):/app" $(DOCKER_IMAGE) -c "bats tests/"

## docker-shell: Start interactive shell in Docker container
docker-shell: docker-build
	@$(DOCKER) run --rm -it -v "$(PWD):/app" $(DOCKER_IMAGE)

## docker-check: Run all checks inside Docker container
docker-check: docker-build
	@echo '$(BOLD)Running checks in Docker...$(RESET)'
	@$(DOCKER) run --rm -v "$(PWD):/app" $(DOCKER_IMAGE) -c "shellcheck -s bash shlib.sh && bats tests/"
	@echo '$(GREEN)All Docker checks passed$(RESET)'

## example: Run the example script
example:
	@bash examples/usage.sh

## man: View the main man page
man:
	@man man/shlib.7

## clean: Remove generated files
clean:
	@echo '$(BOLD)Cleaning...$(RESET)'
	@rm -rf .cache __pycache__ *.log
	@echo '$(GREEN)Clean complete$(RESET)'

## version: Show shlib version
version:
	@bash -c 'source shlib.sh && shlib::version'
