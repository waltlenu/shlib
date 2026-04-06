# @description Sort an array in place (lexicographic order)
# @arg $1 string The name of the array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   my_array=(cherry apple banana)
#   shlib::arr_sort my_array
#   # my_array is now (apple banana cherry)
shlib::arr_sort() {
    local arr_name="$1"
    local IFS=$'\n'
    eval "$arr_name=(\$(printf '%s\n' \"\${$arr_name[@]}\" | sort))"
}
