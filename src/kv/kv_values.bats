@test "shlib::kv_values extracts all values" {
    declare -A kv
    kv[a]="one"
    kv[b]="two"
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 2 ]]
    local found_one=0 found_two=0
    for v in "${values[@]}"; do
        [[ "$v" == "one" ]] && found_one=1
        [[ "$v" == "two" ]] && found_two=1
    done
    [[ $found_one -eq 1 ]]
    [[ $found_two -eq 1 ]]
}

@test "shlib::kv_values handles empty array" {
    declare -A kv
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 0 ]]
}

@test "shlib::kv_values handles values with spaces" {
    declare -A kv
    kv[msg]="hello world"
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 1 ]]
    [[ "${values[0]}" == "hello world" ]]
}
