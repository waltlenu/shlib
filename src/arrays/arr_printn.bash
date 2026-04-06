# @description Print array elements one per line
# @arg $1 string The name of the array variable (without $)
# @stdout Each array element on its own line
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c)
#   shlib::arr_printn my_array
#   # outputs:
#   # a
#   # b
#   # c
shlib::arr_printn() {
    local arr_name="$1"
    eval "printf '%s\n' \"\${$arr_name[@]}\""
}
