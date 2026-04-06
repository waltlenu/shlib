# @description Find all keys with a specific value
# @arg $1 string The name of the destination array variable (without $)
# @arg $2 string The name of the associative array variable (without $)
# @arg $3 string The value to search for
# @exitcode 0 Always succeeds
# @example
#   declare -A roles
#   roles[alice]="admin"
#   roles[bob]="user"
#   roles[carol]="admin"
#   shlib::kv_find admins roles "admin"
#   # admins is now: alice carol
shlib::kv_find() {
    local dest_name="$1"
    local arr_name="$2"
    local search_value="$3"
    local -a keys
    local key

    eval "$dest_name=()"
    eval "keys=(\"\${!$arr_name[@]}\")"
    for key in "${keys[@]}"; do
        local value
        eval "value=\"\${$arr_name[\"\$key\"]}\""
        if [[ "$value" == "$search_value" ]]; then
            eval "$dest_name+=(\"\$key\")"
        fi
    done
}
