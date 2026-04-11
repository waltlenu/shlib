# @description Print a colorized error message to stderr (with newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with ISO8601 timestamp and red "error: " followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_cerrorn "Something went wrong"
#   # outputs: [2024-01-01T12:00:00-05:00] error: Something went wrong
shlib::msg_cerrorn() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    printf '[%s] \033[%sm%s\033[%sm %s\n' "$ts" "${SHLIB_ANSI_FGCODES[1]}" "error:" "${SHLIB_ANSI_STYLECODES[0]}" "$*" >&2
}
