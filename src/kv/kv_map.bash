# @description Apply a transformation command to all values
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The command to apply (receives value via stdin, outputs to stdout)
# @exitcode 0 Always succeeds
# @example
#   declare -A data
#   data[name]="hello"
#   data[greeting]="world"
#   shlib::kv_map data 'tr a-z A-Z'
#   # data is now: name=HELLO greeting=WORLD
shlib::kv_map() {
    local arr_name="$1"
    local cmd="$2"
    local -a keys
    local key

    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value new_value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        # shellcheck disable=SC2034
        new_value=$(echo "$value" | eval "$cmd")
        eval "$arr_name[\"\$key\"]=\"\$new_value\""
    done
}
