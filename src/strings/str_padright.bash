# @description Pad a string on the right to a specified length
# @arg $1 string The string to pad
# @arg $2 int The desired total length
# @arg $3 string The padding character (default: space)
# @stdout The padded string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_padright "hi" 5 "-"  # outputs "hi---"
shlib::str_padright() {
    local str="$1"
    local len="$2"
    local pad="${3:- }"
    while [[ ${#str} -lt $len ]]; do
        str="${str}${pad}"
    done
    echo "$str"
}
