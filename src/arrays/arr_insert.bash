# @description Insert an element at a specific index in an array
# @arg $1 string The name of the array variable (without $)
# @arg $2 int The index at which to insert
# @arg $3 string The element to insert
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_insert my_array 2 "X"
#   # my_array is now (a b X c d)
shlib::arr_insert() {
    local arr_name="$1"
    local index="$2"
    local element="$3"
    local -a result=()
    local len idx

    eval "len=\${#$arr_name[@]}"

    # Clamp index to valid range
    [[ $index -lt 0 ]] && index=0
    [[ $index -gt $len ]] && index=$len

    # Build new array with element inserted
    for ((idx = 0; idx < index; idx++)); do
        eval "result+=(\"\${$arr_name[$idx]}\")"
    done

    result+=("$element")

    for ((idx = index; idx < len; idx++)); do
        eval "result+=(\"\${$arr_name[$idx]}\")"
    done

    eval "$arr_name=(\"\${result[@]}\")"
}
