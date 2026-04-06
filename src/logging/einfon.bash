# @description Print an emoji info message to stdout (with newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with ISO8601 timestamp and "ℹ️ " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::einfon "Processing complete"
#   # outputs: [2024-01-01T12:00:00-05:00] ℹ️  Processing complete
shlib::einfon() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    echo "[$ts] ℹ️  $*"
}
