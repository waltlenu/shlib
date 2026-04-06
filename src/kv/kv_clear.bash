# @description Remove all entries from an associative array
# @arg $1 string The name of the associative array variable (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_clear config
shlib::kv_clear() {
    local arr_name="$1"
    eval "$arr_name=()"
}
