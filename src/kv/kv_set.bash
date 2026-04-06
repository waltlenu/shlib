# @description Set a key-value pair in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to set
# @arg $3 string The value to set
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   shlib::kv_set config "host" "localhost"
shlib::kv_set() {
    local arr_name="$1"
    local key="$2"
    local value="$3"
    eval "$arr_name[\"\$key\"]=\"\$value\""
}
