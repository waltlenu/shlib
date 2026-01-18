# Bats test helper
# This file is sourced by bats before running tests

# Get the directory containing this helper
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${TEST_DIR}")"

# Source the library
source "${PROJECT_ROOT}/shlib.sh"
