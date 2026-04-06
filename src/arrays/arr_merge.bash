# @description Merge multiple arrays into a destination array
# @arg $1 string The name of the destination array variable (without $)
# @arg $@ string Names of source arrays to merge (without $)
# @exitcode 0 Always succeeds
# @example
#   arr1=(a b)
#   arr2=(c d)
#   arr3=(e f)
#   shlib::arr_merge result arr1 arr2 arr3
#   # result is now (a b c d e f)
shlib::arr_merge() {
    local dest_name="$1"
    shift

    # Initialize destination as empty
    eval "$dest_name=()"

    local src_name len idx
    for src_name in "$@"; do
        eval "len=\${#$src_name[@]}"
        for ((idx = 0; idx < len; idx++)); do
            eval "$dest_name+=(\"\${$src_name[$idx]}\")"
        done
    done
}
