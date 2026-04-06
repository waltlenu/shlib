@test "shlib::kv_merge combines multiple arrays" {
    declare -A a
    a[x]="1"
    declare -A b
    b[y]="2"
    declare -A c
    c[z]="3"
    declare -A result
    shlib::kv_merge result a b c
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[x]}" == "1" ]]
    [[ "${result[y]}" == "2" ]]
    [[ "${result[z]}" == "3" ]]
}

@test "shlib::kv_merge handles empty arrays" {
    declare -A a
    a[x]="1"
    declare -A empty
    declare -A b
    b[y]="2"
    declare -A result
    shlib::kv_merge result a empty b
    [[ ${#result[@]} -eq 2 ]]
    [[ "${result[x]}" == "1" ]]
    [[ "${result[y]}" == "2" ]]
}

@test "shlib::kv_merge later arrays override earlier" {
    declare -A defaults
    defaults[host]="localhost"
    defaults[port]="80"
    declare -A overrides
    overrides[port]="8080"
    declare -A result
    shlib::kv_merge result defaults overrides
    [[ ${#result[@]} -eq 2 ]]
    [[ "${result[host]}" == "localhost" ]]
    [[ "${result[port]}" == "8080" ]]
}

@test "shlib::kv_merge with no sources" {
    declare -A result
    shlib::kv_merge result
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_merge with overlapping keys" {
    declare -A a
    a[x]="original"
    a[y]="keep"
    declare -A b
    b[x]="override"
    declare -A result
    shlib::kv_merge result a b
    [[ "${result[x]}" == "override" ]]
    [[ "${result[y]}" == "keep" ]]
}

@test "shlib::kv_merge with single source" {
    declare -A src
    src[key]="value"
    declare -A result
    shlib::kv_merge result src
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[key]}" == "value" ]]
}
