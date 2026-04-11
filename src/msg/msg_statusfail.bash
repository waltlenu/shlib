# @description Print a failure status indicator (without newline)
# @arg $@ string The message to print
# @stdout Red X followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_statusfail "Task failed"
shlib::msg_statusfail() {
    printf '\033[31m✖\033[0m  %s' "$*"
}
