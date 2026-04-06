@test "shlib::kv_exists on empty array" {
    declare -A kv
    run shlib::kv_exists kv "key"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_exists returns 0 for key with empty value" {
    declare -A kv
    kv[empty]=""
    shlib::kv_exists kv "empty"
}

@test "shlib::kv_exists returns 0 when key exists" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_exists kv "host"
}

@test "shlib::kv_exists returns 1 when key missing" {
    declare -A kv
    run shlib::kv_exists kv "missing"
    [[ "${status}" -eq 1 ]]
}
