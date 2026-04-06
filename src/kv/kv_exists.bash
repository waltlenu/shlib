# @description Check if a key exists in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @arg $2 string The key to check
# @exitcode 0 Key exists
# @exitcode 1 Key does not exist
# @example
#   declare -A config
#   config[host]="localhost"
#   shlib::kv_exists config "host" && echo "exists"
shlib::kv_exists() {
    local arr_name="$1"
    local key="$2"
    local exists
    eval "exists=\${$arr_name[\"\$key\"]+exists}"
    [[ -n "$exists" ]]
}
