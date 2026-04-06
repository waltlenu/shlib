# @description Print a failure status indicator (with newline)
# @arg $@ string The message to print
# @stdout Red X followed by message and newline
# @exitcode 0 Always succeeds
# @example
#   shlib::status_failn "Task failed"
shlib::status_failn() {
    shlib::status_fail "$@"
    echo
}
