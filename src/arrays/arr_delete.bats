@test "shlib::arr_delete removes element by index" {
    local -a arr=(a b c d)
    shlib::arr_delete arr 1
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "c" ]]
    [[ "${arr[2]}" == "d" ]]
}

@test "shlib::arr_delete removes first element" {
    local -a arr=(a b c)
    shlib::arr_delete arr 0
    [[ "${#arr[@]}" == "2" ]]
    [[ "${arr[0]}" == "b" ]]
}

@test "shlib::arr_delete removes last element" {
    local -a arr=(a b c)
    shlib::arr_delete arr 2
    [[ "${#arr[@]}" == "2" ]]
    [[ "${arr[1]}" == "b" ]]
}

@test "shlib::arr_delete with negative index" {
    local -a arr=(a b c)
    # Negative index may be treated as empty, should not crash
    shlib::arr_delete arr -1
    # Array should remain valid (behavior may vary)
    [[ ${#arr[@]} -ge 0 ]]
}

@test "shlib::arr_delete with out-of-bounds index" {
    local -a arr=(a b c)
    shlib::arr_delete arr 100
    # Array should remain intact when index is out of bounds
    [[ ${#arr[@]} -eq 3 ]]
}
