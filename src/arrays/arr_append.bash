# @description Append one or more elements to an array
# @arg $1 string The name of the array variable (without $)
# @arg $@ string Elements to append
# @exitcode 0 Always succeeds
# @example
#   my_array=(a b)
#   shlib::arr_append my_array c d
#   # my_array is now (a b c d)
shlib::arr_append() {
    local arr_name="$1"
    shift
    local elem

    for elem in "$@"; do
        eval "$arr_name+=(\"\$elem\")"
    done
}
