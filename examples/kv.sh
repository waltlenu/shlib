#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2154

#
# Example: Key-Value (Associative Array) functions from shlib
#
# Note: Associative arrays require Bash 4.0 or higher
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::headern "Key-Value (Associative Array) Functions"
echo

# Check bash version
if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
    shlib::errorn "Associative arrays require Bash 4.0 or higher (found ${BASH_VERSION})"
    exit 1
fi

#
# Basic Operations
#

shlib::headern "Basic Operations"
echo

# Create an associative array and set values
declare -A config
shlib::kv_set config "host" "localhost"
shlib::kv_set config "port" "8080"
shlib::kv_set config "debug" "true"
echo "After kv_set (host, port, debug):"
shlib::kv_printn config
echo

# Get a value
echo "kv_get config 'host': $(shlib::kv_get config "host")"
echo

# Get with default fallback
echo "kv_get_default config 'timeout' '30': $(shlib::kv_get_default config "timeout" "30")"
echo "kv_get_default config 'port' '80': $(shlib::kv_get_default config "port" "80")"
echo

# Check if key exists
echo "kv_exists config 'host': $(shlib::kv_exists config "host" && echo "true" || echo "false")"
echo "kv_exists config 'missing': $(shlib::kv_exists config "missing" && echo "true" || echo "false")"
echo

# Delete a key
shlib::kv_delete config "debug"
echo "After kv_delete 'debug':"
shlib::kv_printn config
echo

# Get count
echo "kv_len config: $(shlib::kv_len config)"
echo

# Clear all entries
declare -A temp
temp[a]="1"
temp[b]="2"
echo "Before kv_clear: $(shlib::kv_len temp) entries"
shlib::kv_clear temp
echo "After kv_clear: $(shlib::kv_len temp) entries"
echo

#
# Inspection
#

shlib::headern "Inspection Functions"
echo

declare -A settings
settings[theme]="dark"
settings[language]="en"
settings[timezone]="UTC"

echo "Array contents:"
shlib::kv_printn settings
echo

# Get keys into an array
# shellcheck disable=SC2034
shlib::kv_keys key_list settings
echo "kv_keys: ${key_list[*]}"
echo

# Get values into an array
# shellcheck disable=SC2034
shlib::kv_values value_list settings
echo "kv_values: ${value_list[*]}"
echo

# Print inline with custom separators
echo "kv_print (default): $(shlib::kv_print settings)"
echo "kv_print (custom):  $(shlib::kv_print settings ":" ", ")"
echo

#
# Search
#

shlib::headern "Search Functions"
echo

declare -A users
users[alice]="admin"
users[bob]="user"
users[carol]="admin"
users[dave]="user"
users[eve]="guest"

echo "User roles:"
shlib::kv_printn users
echo

# Check if a value exists
echo "kv_has_value users 'admin': $(shlib::kv_has_value users "admin" && echo "true" || echo "false")"
echo "kv_has_value users 'superuser': $(shlib::kv_has_value users "superuser" && echo "true" || echo "false")"
echo

# Find keys with specific value
# shellcheck disable=SC2034
shlib::kv_find admins users "admin"
echo "kv_find users 'admin': ${admins[*]}"

# shellcheck disable=SC2034
shlib::kv_find guests users "guest"
echo "kv_find users 'guest': ${guests[*]}"
echo

#
# Manipulation
#

shlib::headern "Manipulation Functions"
echo

# Copy an array
declare -A original
original[name]="shlib"
original[version]="0.3.5"
declare -A backup
shlib::kv_copy backup original
echo "After kv_copy backup original:"
echo "  original: $(shlib::kv_print original)"
echo "  backup:   $(shlib::kv_print backup)"
echo

# Merge arrays (later overrides earlier)
declare -A defaults
defaults[host]="localhost"
defaults[port]="80"
defaults[ssl]="false"

declare -A production
production[host]="example.com"
production[port]="443"
production[ssl]="true"

declare -A development
development[debug]="true"
development[port]="3000"

echo "defaults:    $(shlib::kv_print defaults)"
echo "production:  $(shlib::kv_print production)"
echo "development: $(shlib::kv_print development)"
echo

declare -A merged_prod
shlib::kv_merge merged_prod defaults production
echo "kv_merge merged_prod defaults production:"
shlib::kv_printn merged_prod
echo

declare -A merged_dev
shlib::kv_merge merged_dev defaults development
echo "kv_merge merged_dev defaults development:"
shlib::kv_printn merged_dev
echo

# Map transformation to all values
declare -A lowercase
lowercase[name]="hello"
lowercase[greeting]="world"
echo "Before kv_map: $(shlib::kv_print lowercase)"
shlib::kv_map lowercase 'tr a-z A-Z'
echo "After kv_map 'tr a-z A-Z': $(shlib::kv_print lowercase)"
echo

#
# Practical Example: Configuration Manager
#

shlib::headern "Practical Example: Configuration Manager"
echo

# Define default configuration
declare -A DEFAULT_CONFIG
DEFAULT_CONFIG[log_level]="info"
DEFAULT_CONFIG[max_connections]="100"
DEFAULT_CONFIG[timeout]="30"
DEFAULT_CONFIG[retry_count]="3"

# Define environment-specific overrides
declare -A ENV_CONFIG
ENV_CONFIG[log_level]="debug"
ENV_CONFIG[max_connections]="10"

# Merge to create final config
declare -A FINAL_CONFIG
shlib::kv_merge FINAL_CONFIG DEFAULT_CONFIG ENV_CONFIG

echo "Default configuration:"
shlib::kv_printn DEFAULT_CONFIG
echo

echo "Environment overrides:"
shlib::kv_printn ENV_CONFIG
echo

echo "Final merged configuration:"
shlib::kv_printn FINAL_CONFIG
echo

# Access configuration values with defaults
echo "Getting configuration values:"
echo "  log_level: $(shlib::kv_get FINAL_CONFIG "log_level")"
echo "  timeout: $(shlib::kv_get FINAL_CONFIG "timeout")"
echo "  cache_ttl (with default): $(shlib::kv_get_default FINAL_CONFIG "cache_ttl" "3600")"
