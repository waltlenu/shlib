# @description Reverse an array in place
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_reverse my_array
#   # my_array is now (d c b a)
shlib::arr_reverse() {
    local arr_name="$1"
    # shellcheck disable=SC2034
    local -a tmp
    local i len
    eval "len=\${#$arr_name[@]}"
    for ((i = len - 1; i >= 0; i--)); do
        eval "tmp+=(\"\${$arr_name[$i]}\")"
    done
    eval "$arr_name=(\"\${tmp[@]}\")"
}
