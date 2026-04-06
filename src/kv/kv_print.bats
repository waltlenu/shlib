@test "shlib::kv_print handles empty array" {
    declare -A kv
    run shlib::kv_print kv
    [[ "${output}" == "" ]]
}

@test "shlib::kv_print handles multiple entries" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    run shlib::kv_print kv "=" ", "
    # Output contains both, order may vary
    [[ "${output}" == *"a=1"* ]]
    [[ "${output}" == *"b=2"* ]]
}

@test "shlib::kv_print with custom separators" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_print kv ":" ", "
    [[ "${output}" == "host:localhost" ]]
}

@test "shlib::kv_print with default separators" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_print kv
    [[ "${output}" == "host=localhost" ]]
}

@test "shlib::kv_printn handles empty array" {
    declare -A kv
    run shlib::kv_printn kv
    [[ "${output}" == "" ]]
}

@test "shlib::kv_printn prints one pair per line" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    run shlib::kv_printn kv
    [[ "${#lines[@]}" -eq 2 ]]
}

@test "shlib::kv_printn with custom separator" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_printn kv ":"
    [[ "${output}" == "host:localhost" ]]
}
