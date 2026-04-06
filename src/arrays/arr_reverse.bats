@test "shlib::arr_reverse handles single element" {
    local -a arr=(only)
    shlib::arr_reverse arr
    [[ "${arr[0]}" == "only" ]]
}

@test "shlib::arr_reverse handles two elements" {
    local -a arr=(first second)
    shlib::arr_reverse arr
    [[ "${arr[0]}" == "second" ]]
    [[ "${arr[1]}" == "first" ]]
}

@test "shlib::arr_reverse reverses array" {
    local -a arr=(a b c d)
    shlib::arr_reverse arr
    [[ "${arr[0]}" == "d" ]]
    [[ "${arr[1]}" == "c" ]]
    [[ "${arr[2]}" == "b" ]]
    [[ "${arr[3]}" == "a" ]]
}

@test "shlib::arr_reverse with empty array" {
    local -a arr=()
    shlib::arr_reverse arr
    [[ ${#arr[@]} -eq 0 ]]
}
