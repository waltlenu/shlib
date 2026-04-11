# @description Print a pending status indicator (without newline)
# @arg $@ string The message to print
# @stdout Yellow hourglass followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_statuspending "Waiting..."
shlib::msg_statuspending() {
    printf '\033[33m⏳\033[0m %s' "$*"
}
