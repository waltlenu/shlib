# @description Print a bold header message to stdout (without newline)
# @arg $@ string The header message to print
# @stdout The message in bold
# @exitcode 0 Always succeeds
# @example
#   shlib::ui_header "Section Title"
shlib::ui_header() {
    printf '\033[%sm%s\033[%sm' "${SHLIB_ANSI_STYLECODES[1]}" "$*" "${SHLIB_ANSI_STYLECODES[0]}"
}
