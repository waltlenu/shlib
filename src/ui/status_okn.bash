# @description Print a success status indicator (with newline)
# @arg $@ string The message to print
# @stdout Green checkmark followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::status_okn "Task completed"
shlib::status_okn() {
    shlib::status_ok "$@"
    echo
}
