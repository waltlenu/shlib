# @description Check if a command exists in PATH
# @arg $1 string The command name to check
# @exitcode 0 Command exists
# @exitcode 1 Command not found
# @example
#   shlib::cmd_exists git
shlib::cmd_exists() {
    command -v "$1" &>/dev/null
}
