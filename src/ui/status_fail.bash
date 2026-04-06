# @description Print a failure status indicator (without newline)
# @arg $@ string The message to print
# @stdout Red X followed by message
# @exitcode 0 Always succeeds
# @example
#   shlib::status_fail "Task failed"
shlib::status_fail() {
    printf '\033[31m✖\033[0m  %s' "$*"
}
