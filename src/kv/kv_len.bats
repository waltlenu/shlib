@test "shlib::kv_len returns 0 for empty array" {
    declare -A kv=()
    run shlib::kv_len kv
    [[ "${output}" == "0" ]]
}

@test "shlib::kv_len returns 1 for single entry" {
    declare -A kv
    kv[only]="one"
    run shlib::kv_len kv
    [[ "${output}" == "1" ]]
}

@test "shlib::kv_len returns correct count" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    kv[c]="3"
    run shlib::kv_len kv
    [[ "${output}" == "3" ]]
}
