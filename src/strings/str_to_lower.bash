# @description Convert a string to lowercase
# @arg $1 string The string to convert
# @stdout The lowercase string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_to_lower "HELLO"
shlib::str_to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}
