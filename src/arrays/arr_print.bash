# @description Print array elements on one line with a separator
# @arg $1 string The name of the array variable (without $)
# @arg $2 string The separator (default: " ")
# @stdout Array elements joined by separator
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c)
#   shlib::arr_print my_array      # outputs "a b c"
#   shlib::arr_print my_array ","  # outputs "a,b,c"
shlib::arr_print() {
    local arr_name="$1"
    # shellcheck disable=SC2034
    local sep="${2:- }"
    local len
    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0
    # shellcheck disable=SC2034,SC2178
    local result="" first=1 elem
    eval "for elem in \"\${$arr_name[@]}\"; do
        if [[ \$first -eq 1 ]]; then
            result=\"\$elem\"
            first=0
        else
            result=\"\$result\$sep\$elem\"
        fi
    done"
    # shellcheck disable=SC2128
    echo "$result"
}
