# @description Print key-value pairs one per line
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string Key-value separator (default: "=")
# @stdout Each key-value pair on its own line
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_printn config
#   # outputs:
#   # host=localhost
#   # port=8080
shlib::kv_printn() {
    local arr_name="$1"
    local kv_sep="${2:-=}"
    local -a keys
    local key

    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        echo "${key}${kv_sep}${value}"
    done
}
