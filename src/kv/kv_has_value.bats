@test "shlib::kv_has_value finds empty string value" {
    declare -A kv
    kv[empty]=""
    shlib::kv_has_value kv ""
}

@test "shlib::kv_has_value handles duplicate values" {
    declare -A kv
    kv[a]="same"
    kv[b]="same"
    shlib::kv_has_value kv "same"
}

@test "shlib::kv_has_value handles empty array" {
    declare -A kv
    run shlib::kv_has_value kv "value"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_has_value returns 0 when value exists" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_has_value kv "localhost"
}

@test "shlib::kv_has_value returns 1 when value missing" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_has_value kv "missing"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_has_value with value containing special chars" {
    declare -A kv
    kv[special]='value*with[chars]'
    shlib::kv_has_value kv 'value*with[chars]'
}
