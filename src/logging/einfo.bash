# @description Print an emoji info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with ISO8601 timestamp and "ℹ️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::einfo "Processing file"
#   # outputs: [2024-01-01T12:00:00-05:00] ℹ️  Processing file
shlib::einfo() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    echo -n "[$ts] ℹ️  $*"
}
