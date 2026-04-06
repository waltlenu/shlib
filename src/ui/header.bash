# @description Print a bold header message to stdout (without newline)
# @arg $@ string The header message to print
# @stdout The message in bold
# @exitcode 0 Always succeeds
# @example
#   shlib::header "Section Title"
shlib::header() {
    printf '\033[%sm%s\033[%sm' "${SHLIB_ANSI_STYLE_CODES[1]}" "$*" "${SHLIB_ANSI_STYLE_CODES[0]}"
}
