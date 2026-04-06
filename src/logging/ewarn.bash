# @description Print an emoji warning message to stdout (without newline)
# @arg $@ string The warning message to print
# @stdout The message prefixed with ISO8601 timestamp and "⚠️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::ewarn "This might cause issues"
#   # outputs: [2024-01-01T12:00:00-05:00] ⚠️  This might cause issues
shlib::ewarn() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    echo -n "[$ts] ⚠️  $*"
}
