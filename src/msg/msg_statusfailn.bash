# @description Print a failure status indicator (with newline)
# @arg $@ string The message to print
# @stdout Red X followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_statusfailn "Task failed"
shlib::msg_statusfailn() {
    shlib::msg_statusfail "$@"
    echo
}
