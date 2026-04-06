@test "shlib::kv_copy copies all entries" {
    declare -A src
    src[host]="localhost"
    src[port]="8080"
    declare -A dest
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 2 ]]
    [[ "${dest[host]}" == "localhost" ]]
    [[ "${dest[port]}" == "8080" ]]
}

@test "shlib::kv_copy handles empty source" {
    declare -A src
    declare -A dest
    dest[old]="data"
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 0 ]]
}

@test "shlib::kv_copy handles values with newlines" {
    declare -A src
    src[multi]=$'line1\nline2'
    declare -A dest
    shlib::kv_copy dest src
    [[ "${dest[multi]}" == $'line1\nline2' ]]
}

@test "shlib::kv_copy handles values with spaces" {
    declare -A src
    src[msg]="hello world"
    declare -A dest
    shlib::kv_copy dest src
    [[ "${dest[msg]}" == "hello world" ]]
}

@test "shlib::kv_copy overwrites destination" {
    declare -A src
    src[new]="value"
    declare -A dest
    dest[old]="data"
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 1 ]]
    [[ "${dest[new]}" == "value" ]]
    [[ -z "${dest[old]+exists}" ]]
}
