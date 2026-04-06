# @description Merge multiple associative arrays (later arrays override earlier)
# @arg $1 string The name of the destination associative array (without $)
# @arg $@ string Names of source associative arrays to merge (without $)
# @exitcode 0 Always succeeds
# @example
#   declare -A defaults
#   defaults[host]="localhost"
#   defaults[port]="80"
#   declare -A overrides
#   overrides[port]="8080"
#   declare -A result
#   shlib::kv_merge result defaults overrides
#   # result is now: host=localhost port=8080
shlib::kv_merge() {
    local dest_name="$1"
    shift

    eval "$dest_name=()"
    local src_name
    for src_name in "$@"; do
        local -a keys
        local key
        eval "keys=(\"\${!$src_name[@]}\")"
        for key in "${keys[@]}"; do
            local value
            eval "value=\"\${$src_name[\"\$key\"]}\""
            eval "$dest_name[\"\$key\"]=\"\$value\""
        done
    done
}
