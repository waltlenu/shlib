@test "shlib::arr_sort handles numbers as strings" {
    local -a arr=(10 2 1 20)
    shlib::arr_sort arr
    [[ "${arr[0]}" == "1" ]]
    [[ "${arr[1]}" == "10" ]]
    [[ "${arr[2]}" == "2" ]]
    [[ "${arr[3]}" == "20" ]]
}

@test "shlib::arr_sort handles single element" {
    local -a arr=(only)
    shlib::arr_sort arr
    [[ "${arr[0]}" == "only" ]]
}

@test "shlib::arr_sort sorts alphabetically" {
    local -a arr=(cherry apple banana)
    shlib::arr_sort arr
    [[ "${arr[0]}" == "apple" ]]
    [[ "${arr[1]}" == "banana" ]]
    [[ "${arr[2]}" == "cherry" ]]
}

@test "shlib::arr_sort with empty array" {
    local -a arr=()
    shlib::arr_sort arr
    [[ ${#arr[@]} -eq 0 ]]
}
