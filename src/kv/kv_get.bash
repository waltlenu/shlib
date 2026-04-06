# @description Get a value by key from an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to look up
# @stdout The value associated with the key
# @exitcode 0 Key exists
# @exitcode 1 Key not found
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_get config "host"  # outputs: localhost
shlib::kv_get() {
    local arr_name="$1"
    local key="$2"
    local exists
    eval "exists=\${$arr_name[\"\$key\"]+exists}"
    if [[ -n "$exists" ]]; then
        eval "echo \"\${$arr_name[\"\$key\"]}\""
        return 0
    fi
    return 1
}
