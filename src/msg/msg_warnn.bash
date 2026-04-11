# @description Print a warning message to stdout (with newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with ISO8601 timestamp and "warning: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_warnn "This might cause issues"
#   # outputs: [2024-01-01T12:00:00-05:00] warning: This might cause issues
shlib::msg_warnn() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    echo "[$ts] warning: $*"
}
