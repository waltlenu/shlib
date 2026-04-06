# @description Copy an associative array to another
# @arg $1 string The name of the destination associative array (without $)
# @arg $2 string The name of the source associative array (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A original
#   original[host]="localhost"
#   declare -A copy
#   shlib::kv_copy copy original
shlib::kv_copy() {
    local dest_name="$1"
    local src_name="$2"
    local -a keys
    local key

    eval "$dest_name=()"
    eval "keys=(\"\${!$src_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$src_name[\"\$key\"]}\""
        eval "$dest_name[\"\$key\"]=\"\$value\""
    done
}
