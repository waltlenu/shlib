@test "shlib::kv_clear on empty array" {
    declare -A kv
    shlib::kv_clear kv
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_clear removes all entries" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    shlib::kv_clear kv
    [[ ${#kv[@]} -eq 0 ]]
}
