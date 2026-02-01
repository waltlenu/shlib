#!/usr/bin/env bash

#
# Example: System functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::headern "Command System Functions"

# Check for commands
if shlib::cmd_exists git; then
    shlib::cinfon "git is installed"
else
    shlib::cwarnn "git is not installed"
fi

if shlib::cmd_exists nonexistent_cmd; then
    shlib::cinfon "nonexistent_cmd is installed"
else
    shlib::cwarnn "nonexistent_cmd is not installed (expected)"
fi

echo

shlib::headern "Command Timeout"

# Run a command with timeout
if shlib::cmd_timeout 2 sleep 1; then
    shlib::cinfon "Command completed within timeout"
fi

# Command that times out
if ! shlib::cmd_timeout 1 sleep 5; then
    shlib::cwarnn "Command timed out (expected)"
fi

echo

shlib::headern "Command Retry"

# Command that succeeds on first try
if shlib::cmd_retry 3 0 true; then
    shlib::cinfon "Command succeeded"
fi

# Command that always fails
if ! shlib::cmd_retry 2 0 false; then
    shlib::cwarnn "Command failed after 2 attempts (expected)"
fi

# Retry with delay between attempts
tmpfile=$(mktemp)
echo "0" > "$tmpfile"
if shlib::cmd_retry 3 1 bash -c '
    count=$(cat "'"$tmpfile"'")
    count=$((count + 1))
    echo "$count" > "'"$tmpfile"'"
    [ "$count" -ge 2 ]
'; then
    shlib::cinfon "Command succeeded on attempt 2 (with 1s delay between)"
fi
rm -f "$tmpfile"
