# @description Remove the last element from an array
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_pop my_array
#   # my_array is now (a b c)
shlib::arr_pop() {
    local arr_name="$1"
    local len
    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0
    eval "unset '$arr_name[$((len - 1))]'"
}
