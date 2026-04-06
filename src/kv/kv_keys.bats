@test "shlib::kv_keys extracts all keys" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 2 ]]
    # Keys may be in any order, check both exist
    local found_host=0 found_port=0
    for k in "${keys[@]}"; do
        [[ "$k" == "host" ]] && found_host=1
        [[ "$k" == "port" ]] && found_port=1
    done
    [[ $found_host -eq 1 ]]
    [[ $found_port -eq 1 ]]
}

@test "shlib::kv_keys handles empty array" {
    declare -A kv
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 0 ]]
}

@test "shlib::kv_keys handles single entry" {
    declare -A kv
    kv[only]="value"
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 1 ]]
    [[ "${keys[0]}" == "only" ]]
}
