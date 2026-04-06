@test "shlib::kv_set handles empty value" {
    declare -A kv
    shlib::kv_set kv "key" ""
    [[ "${kv[key]}" == "" ]]
    [[ -n "${kv[key]+exists}" ]]
}

@test "shlib::kv_set handles key with special characters" {
    declare -A kv
    shlib::kv_set kv "my-key_1" "value"
    [[ "${kv['my-key_1']}" == "value" ]]
}

@test "shlib::kv_set handles key with underscore and hyphen" {
    declare -A kv
    shlib::kv_set kv "my_key-name" "value"
    [[ "${kv['my_key-name']}" == "value" ]]
}

@test "shlib::kv_set handles value with backslash" {
    declare -A kv
    shlib::kv_set kv "path" 'C:\Users\test'
    [[ "${kv[path]}" == 'C:\Users\test' ]]
}

@test "shlib::kv_set handles value with quotes" {
    declare -A kv
    shlib::kv_set kv "msg" 'hello "world"'
    [[ "${kv[msg]}" == 'hello "world"' ]]
}

@test "shlib::kv_set handles value with spaces" {
    declare -A kv
    shlib::kv_set kv "message" "hello world"
    [[ "${kv[message]}" == "hello world" ]]
}

@test "shlib::kv_set overwrites existing key" {
    declare -A kv
    kv[host]="old"
    shlib::kv_set kv "host" "new"
    [[ "${kv[host]}" == "new" ]]
}

@test "shlib::kv_set sets a key-value pair" {
    declare -A kv
    shlib::kv_set kv "host" "localhost"
    [[ "${kv[host]}" == "localhost" ]]
}

@test "shlib::kv_set with numeric key" {
    declare -A kv
    shlib::kv_set kv "123" "numeric key"
    [[ "${kv[123]}" == "numeric key" ]]
}
