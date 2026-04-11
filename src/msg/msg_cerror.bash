# @description Print a colorized error message to stderr (without newline)
# @arg $@ string The error message to print
# @stderr The message prefixed with ISO8601 timestamp and red "error: "
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_cerror "Something went wrong"
#   # outputs: [2024-01-01T12:00:00-05:00] error: Something went wrong
shlib::msg_cerror() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    printf '[%s] \033[%sm%s\033[%sm %s' "$ts" "${SHLIB_ANSI_FG_CODES[1]}" "error:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*" >&2
}
