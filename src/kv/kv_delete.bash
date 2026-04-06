# @description Delete a key from an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to delete
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_delete config "host"
shlib::kv_delete() {
    local arr_name="$1"
    local key="$2"
    eval "unset '$arr_name[\"\$key\"]'"
}
