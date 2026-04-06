# @description Pad a string on the left to a specified length
# @arg $1 string The string to pad
# @arg $2 int The desired total length
# @arg $3 string The padding character (default: space)
# @stdout The padded string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_padleft "42" 5 "0"  # outputs "00042"
shlib::str_padleft() {
    local str="$1"
    local len="$2"
    local pad="${3:- }"
    while [[ ${#str} -lt $len ]]; do
        str="${pad}${str}"
    done
    echo "$str"
}
