# @description Print an info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with ISO8601 timestamp and "info: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_infon "Processing complete"
#   # outputs: [2024-01-01T12:00:00-05:00] info: Processing complete
shlib::msg_infon() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    echo "[$ts] info: $*"
}
