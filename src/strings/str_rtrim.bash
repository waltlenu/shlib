# @description Remove trailing whitespace from a string
# @arg $1 string The string to trim
# @stdout The string with trailing whitespace removed
# @exitcode 0 Always succeeds
# @example
#   shlib::str_rtrim "hello world  "
shlib::str_rtrim() {
    local str="$1"
    echo "${str%"${str##*[![:space:]]}"}"
}
