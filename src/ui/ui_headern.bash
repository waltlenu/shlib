# @description Print a bold header message to stdout (with newline)
# @arg $@ string The header message to print
# @stdout The message in bold followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::ui_headern "Section Title"
shlib::ui_headern() {
    printf '\033[%sm%s\033[%sm\n' "${SHLIB_ANSI_STYLECODES[1]}" "$*" "${SHLIB_ANSI_STYLECODES[0]}"
}
