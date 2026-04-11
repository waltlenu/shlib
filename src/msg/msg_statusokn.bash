# @description Print a success status indicator (with newline)
# @arg $@ string The message to print
# @stdout Green checkmark followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_statusokn "Task completed"
shlib::msg_statusokn() {
    shlib::msg_statusok "$@"
    echo
}
