# @description Print a colorized info message to stdout (without newline)
# @arg $@ string The info message to print
# @stdout The message prefixed with ISO8601 timestamp and blue "info: "
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_cinfo "Processing file"
#   # outputs: [2024-01-01T12:00:00-05:00] info: Processing file
shlib::msg_cinfo() {
    local ts
    ts=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
    printf '[%s] \033[%sm%s\033[%sm %s' "$ts" "${SHLIB_ANSI_FG_CODES[4]}" "info:" "${SHLIB_ANSI_STYLE_CODES[0]}" "$*"
}
