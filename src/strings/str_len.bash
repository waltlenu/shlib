# @description Get the length of a string
# @arg $1 string The string to measure
# @stdout The length of the string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_len "hello"
shlib::str_len() {
    echo "${#1}"
}
