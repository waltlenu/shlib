# @description Print a success status indicator (without newline)
# @arg $@ string The message to print
# @stdout Green checkmark followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::msg_statusok "Task completed"
shlib::msg_statusok() {
    printf '\033[32m✔\033[0m  %s' "$*"
}
