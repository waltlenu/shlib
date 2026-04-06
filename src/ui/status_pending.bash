# @description Print a pending status indicator (without newline)
# @arg $@ string The message to print
# @stdout Yellow hourglass followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::status_pending "Waiting..."
shlib::status_pending() {
    printf '\033[33m⏳\033[0m %s' "$*"
}
