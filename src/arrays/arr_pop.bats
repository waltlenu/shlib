@test "shlib::arr_pop on empty array does nothing" {
    local -a arr=()
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "0" ]]
}

@test "shlib::arr_pop on single element array" {
    local -a arr=(only)
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "0" ]]
}

@test "shlib::arr_pop removes last element" {
    local -a arr=(a b c d)
    shlib::arr_pop arr
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[2]}" == "c" ]]
}
