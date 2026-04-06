# @description Get the number of elements in an array
# @arg $1 string The name of the array variable (without $)
# @stdout The number of elements in the array
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b c d e)
#   shlib::arr_len my_array  # outputs 5
shlib::arr_len() {
    eval "echo \${#$1[@]}"
}
