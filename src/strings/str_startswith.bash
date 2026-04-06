# @description Check if a string starts with a prefix
# @arg $1 string The string to check
# @arg $2 string The prefix to check for
# @exitcode 0 String starts with prefix
# @exitcode 1 String does not start with prefix
# @example
#   shlib::str_startswith "hello world" "hello" && echo "yes"
shlib::str_startswith() {
    [[ "$1" == "$2"* ]]
}
