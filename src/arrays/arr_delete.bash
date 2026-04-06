# @description Delete an element from an array by index
# @arg $1 string The name of the array variable (without $)
# @arg $2 int The index to delete
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d)
#   shlib::arr_delete my_array 1
#   # my_array is now (a c d)
shlib::arr_delete() {
    local arr_name="$1"
    local index="$2"
    eval "unset '$arr_name[$index]'"
    eval "$arr_name=(\"\${$arr_name[@]}\")"
}
