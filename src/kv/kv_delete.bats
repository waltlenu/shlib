@test "shlib::kv_delete handles missing key" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_delete kv "missing"
    [[ "${kv[host]}" == "localhost" ]]
}

@test "shlib::kv_delete on empty array" {
    declare -A kv=()
    shlib::kv_delete kv "key"
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_delete removes a key" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    shlib::kv_delete kv "host"
    [[ -z "${kv[host]+exists}" ]]
    [[ "${kv[port]}" == "8080" ]]
}
