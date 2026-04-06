# @description Get the count of entries in an associative array
# @arg $1 string The name of the associative array variable (without $)
# @stdout The number of key-value pairs
# @exitcode 0 Always succeeds
# @example
#   declare -A config
#   config[host]="localhost"
#   config[port]="8080"
#   shlib::kv_len config  # outputs: 2
shlib::kv_len() {
    eval "echo \${#$1[@]}"
}
