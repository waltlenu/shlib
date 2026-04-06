# @description Check if a value exists in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The value to search for
# @exitcode 0 Value exists
# @exitcode 1 Value does not exist
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_has_value config "localhost" && echo "found"
shlib::kv_has_value() {
    local arr_name="$1"
    local search_value="$2"
    local -a keys
    local key

    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        if [[ "$value" == "$search_value" ]]; then
            return 0
        fi
    done
    return 1
}
