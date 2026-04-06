# @description Check if a string contains a substring
# @arg $1 string The string to search in
# @arg $2 string The substring to search for
# @exitcode 0 String contains substring
# @exitcode 1 String does not contain substring
# @example
#   shlib::str_contains "hello world" "world" && echo "found"
shlib::str_contains() {
    [[ "$1" == *"$2"* ]]
}
