# @description Print an emoji error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with ISO8601 timestamp and "❌️ "
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_eerror "Something went wrong"
#   # outputs: [2024-01-01T12:00:00-05:00] ❌️  Something went wrong
shlib::msg_eerror() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    echo -n "[$ts] ❌️  $*" >&2
}
