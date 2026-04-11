# @description Convert a string to uppercase
# @arg $1 string The string to convert
# @stdout The uppercase string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_toupper "hello"
shlib::str_toupper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}
