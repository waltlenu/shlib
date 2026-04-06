# @description Print key-value pairs on one line with separators
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string Key-value separator (default: "=")
# @arg $3 string Pair separator (default: " ")
# @stdout Key-value pairs joined by separators
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_print config           # outputs: host=localhost port=8080
#   shlib::kv_print config ":" ", "  # outputs: host:localhost, port:8080
shlib::kv_print() {
    local arr_name="$1"
    local kv_sep="${2:-=}"
    local pair_sep="${3:- }"
    local -a keys
    local key first=1 output_str=""

    eval "keys=(\"\${!$arr_name[@]}\")"
    [[ ${#keys[@]} -eq 0 ]] && return 0

    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        if [[ $first -eq 1 ]]; then
            output_str="${key}${kv_sep}${value}"
            first=0
        else
            output_str="${output_str}${pair_sep}${key}${kv_sep}${value}"
        fi
    done
    echo "$output_str"
}
