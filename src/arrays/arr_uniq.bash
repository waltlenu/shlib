# @description Remove duplicate elements from an array (keeps first occurrence)
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b a c b d)
#   shlib::arr_uniq my_array
#   # my_array is now (a b c d)
shlib::arr_uniq() {
    local arr_name="$1"
    local -a result=()
    local len idx elem found j

    eval "len=\${#$arr_name[@]}"
    [[ $len -eq 0 ]] && return 0

    for ((idx = 0; idx < len; idx++)); do
        eval "elem=\${$arr_name[$idx]}"
        found=0
        for ((j = 0; j < ${#result[@]}; j++)); do
            if [[ "${result[$j]}" == "$elem" ]]; then
                found=1
                break
            fi
        done
        if [[ $found -eq 0 ]]; then
            result+=("$elem")
        fi
    done

    eval "$arr_name=(\"\${result[@]}\")"
}
