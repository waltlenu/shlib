# syntax=docker/dockerfile:1
#
# shlib development container
#
# Provides a minimal Alpine-based environment with all tools needed
# to develop, lint, format, and test the shlib library.
#
# Build:
#   docker build -t shlib .
#
# Run tests:
#   docker run --rm -v "$PWD:/app" shlib -c "bats tests/"
#
# Run shellcheck:
#   docker run --rm -v "$PWD:/app" shlib -c "shellcheck -s bash shlib.sh"
#
# Interactive shell:
#   docker run --rm -it -v "$PWD:/app" shlib
#

# Use specific Alpine version for reproducibility
FROM alpine:3.19

# Labels following OCI image spec
LABEL org.opencontainers.image.title="shlib" \
      org.opencontainers.image.description="Development environment for shlib - a shell library of reusable Bash functions" \
      org.opencontainers.image.source="https://github.com/waltlenu/shlib" \
      org.opencontainers.image.licenses="MIT"

# Install all dependencies in a single layer
# - bash: required runtime for shlib
# - bats: testing framework
# - shellcheck: static analysis for shell scripts
# - shfmt: shell script formatter
# --no-cache: don't cache the index locally (smaller image)
RUN apk add --no-cache \
        bash \
        bats \
        shellcheck \
        shfmt \
    # Verify installations
    && bash --version \
    && bats --version \
    && shellcheck --version \
    && shfmt --version

# Set working directory
WORKDIR /app

# Use bash as the default shell and entrypoint
# -l: login shell (loads profile)
# Using exec form for proper signal handling
ENTRYPOINT ["/bin/bash", "-l"]
