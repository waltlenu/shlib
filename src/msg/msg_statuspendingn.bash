# @description Print a pending status indicator (with newline)
# @arg $@ string The message to print
# @stdout Yellow hourglass followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_statuspendingn "Waiting..."
shlib::msg_statuspendingn() {
    shlib::msg_statuspending "$@"
    echo
}
