# @description Split a string into an array using a separator
# @arg $1 string The name of the array variable to store results (without $)
# @arg $2 string The string to split
# @arg $3 string The separator (default: " ")
# @exitcode 0 Always succeeds
# @example
#   shlib::str_split result "a,b,c" ","
#   # result is now (a b c)
shlib::str_split() {
    local arr_name="$1"
    local str="$2"
    local sep="${3- }"

    # Initialize array as empty
    eval "$arr_name=()"

    # Handle empty string
    [[ -z "$str" ]] && return 0

    # Handle empty separator - split into characters
    if [[ -z "$sep" ]]; then
        local i
        for ((i = 0; i < ${#str}; i++)); do
            eval "$arr_name+=(\"\${str:\$i:1}\")"
        done
        return 0
    fi

    # Split string by separator
    local remaining="$str"
    local part

    while true; do
        if [[ "$remaining" == *"$sep"* ]]; then
            # shellcheck disable=SC2034
            part="${remaining%%"$sep"*}"
            eval "$arr_name+=(\"\$part\")"
            remaining="${remaining#*"$sep"}"
        else
            # Last part (or only part if no separator found)
            eval "$arr_name+=(\"\$remaining\")"
            break
        fi
    done

    return 0
}
