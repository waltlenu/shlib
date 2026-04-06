# @description Check if a string ends with a suffix
# @arg $1 string The string to check
# @arg $2 string The suffix to check for
# @exitcode 0 String ends with suffix
# @exitcode 1 String does not end with suffix
# @example
#   shlib::str_endswith "hello world" "world" && echo "yes"
shlib::str_endswith() {
    [[ "$1" == *"$2" ]]
}
