# @description Get a value by key with a fallback default
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to look up
# @arg $3 string The default value if key not found
# @stdout The value associated with the key, or default if not found
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   shlib::kv_get_default config "port" "8080"  # outputs: 8080
shlib::kv_get_default() {
    local arr_name="$1"
    local key="$2"
    local default="$3"
    local exists
    eval "exists=\${$arr_name[\"\$key\"]+exists}"
    if [[ -n "$exists" ]]; then
        eval "echo \"\${$arr_name[\"\$key\"]}\""
    else
        echo "$default"
    fi
}
