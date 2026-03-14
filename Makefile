# shlib - A library of reusable Bash shell functions
#
# Usage:
#   make help   - Show available targets
#   make all    - Run all checks (lint + test)


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
EXAMPLE_FILES := $(wildcard examples/*.sh)
HACK_FILES := $(wildcard hack/*.sh)
TEST_FILES := $(wildcard tests/*.bats)
ALL_SHELL_FILES := $(SHELL_FILES) $(EXAMPLE_FILES) $(HACK_FILES) $(TEST_FILES)

# Colors for output
BOLD := $(shell tput bold 2>/dev/null || echo '')
GREEN := $(shell tput setaf 2 2>/dev/null || echo '')
YELLOW := $(shell tput setaf 3 2>/dev/null || echo '')
RESET := $(shell tput sgr0 2>/dev/null || echo '')

# Default target
.DEFAULT_GOAL := help

# Phony targets
.PHONY: all lint format test \
		example man changelog release-notes version hels

## help: Show this help message
help:
	@echo '$(BOLD)shlib$(RESET) - A library of reusable Bash shell functions'
	@echo ''
	@echo '$(BOLD)Usage:$(RESET)'
	@echo '  make $(GREEN)<target>$(RESET)'
	@echo ''
	@echo '$(BOLD)Targets:$(RESET)'
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':' | sed 's/^/  /'

## all: Run all linters, formatters, tests
all: lint format test
	@echo '$(GREEN)All checks passed$(RESET)'

## lint: Run static analysis
lint:
	@echo '$(BOLD)Running shellcheck...$(RESET)'
	@$(SHELLCHECK) $(SHELLCHECK_OPTS) $(ALL_SHELL_FILES)
	@echo '$(GREEN)shellcheck passed$(RESET)'

## format: Check for code formatting
format:
	@echo '$(BOLD)Running shfmt...$(RESET)'
	@$(SHFMT) $(SHFMT_OPTS) -d $(ALL_SHELL_FILES)
	@echo '$(GREEN)Formatting check passed$(RESET)'

## test: Unit-Test all functions
test:
	@echo '$(BOLD)Running BATS...$(RESET)'
	@$(BATS) tests/
	@echo '$(GREEN)All tests passed$(RESET)'

## example: Run the example script
example:
	@bash examples/usage.sh

## man: View the main man page
man:
	@man man/shlib.7

## changelog: Generate changelog.md from git history
changelog:
	@./hack/changelog.sh

## release-notes: Generate changelog to stdout
release-notes:
	@./hack/changelog.sh --stdout

## version: Show shlib version
version:
	@bash -c 'source shlib.sh && shlib::version'
