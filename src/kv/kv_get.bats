@test "shlib::kv_getdefault handles default with spaces" {
    declare -A kv
    run shlib::kv_getdefault kv "missing" "hello world"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::kv_getdefault returns default when key missing" {
    declare -A kv
    run shlib::kv_getdefault kv "port" "8080"
    [[ "${output}" == "8080" ]]
}

@test "shlib::kv_getdefault returns empty value over default" {
    declare -A kv
    kv[empty]=""
    run shlib::kv_getdefault kv "empty" "default"
    [[ "${output}" == "" ]]
}

@test "shlib::kv_getdefault returns value when key exists" {
    declare -A kv
    kv[port]="3000"
    run shlib::kv_getdefault kv "port" "8080"
    [[ "${output}" == "3000" ]]
}

@test "shlib::kv_get handles empty value" {
    declare -A kv
    kv[empty]=""
    run shlib::kv_get kv "empty"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" == "" ]]
}

@test "shlib::kv_get handles value with spaces" {
    declare -A kv
    kv[message]="hello world"
    run shlib::kv_get kv "message"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::kv_get retrieves existing key" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_get kv "host"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" == "localhost" ]]
}

@test "shlib::kv_get returns 1 for missing key" {
    declare -A kv
    run shlib::kv_get kv "missing"
    [[ "${status}" -eq 1 ]]
    [[ "${output}" == "" ]]
}

@test "shlib::kv_get with numeric key" {
    declare -A kv
    kv[123]="numeric value"
    run shlib::kv_get kv "123"
    [[ "${output}" == "numeric value" ]]
}
