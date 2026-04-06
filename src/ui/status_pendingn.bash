# @description Print a pending status indicator (with newline)
# @arg $@ string The message to print
# @stdout Yellow hourglass followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::status_pendingn "Waiting..."
shlib::status_pendingn() {
    shlib::status_pending "$@"
    echo
}
