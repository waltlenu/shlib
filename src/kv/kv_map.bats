@test "shlib::kv_map handles empty array" {
    declare -A kv=()
    shlib::kv_map kv 'tr a-z A-Z'
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_map preserves keys when transforming values" {
    declare -A kv
    kv[key1]="value1"
    kv[key2]="value2"
    shlib::kv_map kv 'tr a-z A-Z'
    [[ -n "${kv[key1]+exists}" ]]
    [[ -n "${kv[key2]+exists}" ]]
    [[ "${kv[key1]}" == "VALUE1" ]]
    [[ "${kv[key2]}" == "VALUE2" ]]
}

@test "shlib::kv_map transforms all values" {
    declare -A kv
    kv[name]="hello"
    kv[greeting]="world"
    shlib::kv_map kv 'tr a-z A-Z'
    [[ "${kv[name]}" == "HELLO" ]]
    [[ "${kv[greeting]}" == "WORLD" ]]
}

@test "shlib::kv_map with sed replacement" {
    declare -A kv
    kv[path]="/old/path"
    shlib::kv_map kv "sed 's/old/new/'"
    [[ "${kv[path]}" == "/new/path" ]]
}

@test "shlib::kv_map with simple echo" {
    declare -A kv
    kv[a]="test"
    shlib::kv_map kv 'cat'
    [[ "${kv[a]}" == "test" ]]
}
