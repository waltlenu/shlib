# shlib - A library of reusable Bash shell functions
#
# Usage:
#   make help   - Show available targets
#   make all    - Build, lint, format-check, and test

# Shell configuration
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Tools
SHELLCHECK := shellcheck
SHFMT := shfmt
BATS := bats
GO := go

# Tool options
SHELLCHECK_OPTS := -s bash
SHFMT_OPTS := -i 4 -ci -bn

# Files
SHELL_FILE := shlib.bash
TEST_FILE := shlib.bats
EXAMPLE_FILE := shlib.example.bash
MAN_FILE := shlib.7
PARAMS_FILE := params.json
ALL_SHELL_FILES := $(SHELL_FILE) $(TEST_FILE) $(EXAMPLE_FILE)
ALL_OUTPUT_FILES := $(ALL_SHELL_FILES) $(MAN_FILE)

# Build tool
RENDER_SRC := ./hack/render.go
RENDER_BIN := ./hack/render

# Colors for output
BOLD := $(shell tput bold 2>/dev/null || echo '')
GREEN := $(shell tput setaf 2 2>/dev/null || echo '')
RESET := $(shell tput sgr0 2>/dev/null || echo '')

# Default target
.DEFAULT_GOAL := help

# Phony targets
.PHONY: help all build lint format fmt test example man version clean

## help: Show this help message
help:
	@echo '$(BOLD)shlib$(RESET) - A library of reusable Bash shell functions'
	@echo ''
	@echo '$(BOLD)Usage:$(RESET)'
	@echo '  make $(GREEN)<target>$(RESET)'
	@echo ''
	@echo '$(BOLD)Targets:$(RESET)'
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':' | sed 's/^/  /'

## all: Run all builds, linters, formatters, tests
all: build lint format test
	@echo '$(GREEN)All checks passed$(RESET)'

## build: Assemble output files from src/ fragments
build: $(RENDER_BIN)
	@for f in $(ALL_OUTPUT_FILES); do \
		$(RENDER_BIN) -f $(PARAMS_FILE) -t tmpl/$${f}.gotmpl -o $${f}; \
	done

$(RENDER_BIN): $(RENDER_SRC)
	@$(GO) build -o $(RENDER_BIN) $(RENDER_SRC)

## lint: Run static analysis
lint: build
	@echo '$(BOLD)Running shellcheck...$(RESET)'
	@$(SHELLCHECK) $(SHELLCHECK_OPTS) $(ALL_SHELL_FILES)
	@echo '$(GREEN)shellcheck passed$(RESET)'

## format: Check code formatting
format: build
	@echo '$(BOLD)Running shfmt...$(RESET)'
	@$(SHFMT) $(SHFMT_OPTS) -d $(ALL_SHELL_FILES)
	@echo '$(GREEN)Formatting check passed$(RESET)'

## fmt: Auto-fix code formatting
fmt: build
	@$(SHFMT) $(SHFMT_OPTS) -w $(ALL_SHELL_FILES)
	@echo '$(GREEN)Formatting applied$(RESET)'

## test: Unit-test all functions
test: build
	@echo '$(BOLD)Running BATS...$(RESET)'
	@$(BATS) $(TEST_FILE)
	@echo '$(GREEN)All tests passed$(RESET)'

## example: Run the example script
example: build
	@bash $(EXAMPLE_FILE)

## man: View the man page
man: build
	@man ./$(MAN_FILE)

## version: Show shlib version
version: build
	@bash -c 'source $(SHELL_FILE) && shlib::version'

## clean: Remove generated files
clean:
	@rm -f $(ALL_OUTPUT_FILES) $(RENDER_BIN)
	@echo '$(GREEN)Cleaned$(RESET)'
