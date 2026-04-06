# @description Repeat a string N times
# @arg $1 string The string to repeat
# @arg $2 int The number of times to repeat (default: 1)
# @stdout The repeated string
# @exitcode 0 Always succeeds
# @example
#   shlib::str_repeat "ab" 3  # outputs "ababab"
#   shlib::str_repeat "-" 10  # outputs "----------"
shlib::str_repeat() {
    local str="$1"
    local count="${2:-1}"
    local out=""
    local i

    for ((i = 0; i < count; i++)); do
        out="${out}${str}"
    done
    echo "$out"
}
