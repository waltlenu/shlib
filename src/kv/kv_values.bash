# @description Get all values from an associative array into a regular array
# @arg $1 string The name of the destination array variable (without $)
# @arg $2 string The name of the associative array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_values values config
#   # values is now an array of: localhost 8080 (order may vary)
shlib::kv_values() {
    local dest_name="$1"
    local arr_name="$2"
    eval "$dest_name=(\"\${$arr_name[@]}\")"
}
