@test "shlib::kv_find handles empty array" {
    declare -A kv
    local -a result
    shlib::kv_find result kv "value"
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_find returns empty when no match" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    local -a result
    shlib::kv_find result kv "missing"
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_find returns keys with matching value" {
    declare -A roles
    roles[alice]="admin"
    roles[bob]="user"
    roles[carol]="admin"
    local -a result
    shlib::kv_find result roles "admin"
    [[ ${#result[@]} -eq 2 ]]
    local found_alice=0 found_carol=0
    for k in "${result[@]}"; do
        [[ "$k" == "alice" ]] && found_alice=1
        [[ "$k" == "carol" ]] && found_carol=1
    done
    [[ $found_alice -eq 1 ]]
    [[ $found_carol -eq 1 ]]
}

@test "shlib::kv_find returns single match" {
    declare -A kv
    kv[a]="unique"
    kv[b]="other"
    local -a result
    shlib::kv_find result kv "unique"
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[0]}" == "a" ]]
}

@test "shlib::kv_find searching for empty string value" {
    declare -A kv
    kv[empty1]=""
    kv[empty2]=""
    kv[filled]="value"
    local -a result
    shlib::kv_find result kv ""
    [[ ${#result[@]} -eq 2 ]]
}
