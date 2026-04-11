@test "shlib::kv_hasvalue finds empty string value" {
    declare -A kv
    kv[empty]=""
    shlib::kv_hasvalue kv ""
}

@test "shlib::kv_hasvalue handles duplicate values" {
    declare -A kv
    kv[a]="same"
    kv[b]="same"
    shlib::kv_hasvalue kv "same"
}

@test "shlib::kv_hasvalue handles empty array" {
    declare -A kv
    run shlib::kv_hasvalue kv "value"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_hasvalue returns 0 when value exists" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_hasvalue kv "localhost"
}

@test "shlib::kv_hasvalue returns 1 when value missing" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_hasvalue kv "missing"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_hasvalue with value containing special chars" {
    declare -A kv
    kv[special]='value*with[chars]'
    shlib::kv_hasvalue kv 'value*with[chars]'
}
