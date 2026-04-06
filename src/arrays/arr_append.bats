@test "shlib::arr_append adds multiple elements" {
    local -a arr=(a)
    shlib::arr_append arr b c d
    [[ "${#arr[@]}" == "4" ]]
    [[ "${arr[3]}" == "d" ]]
}

@test "shlib::arr_append adds single element" {
    local -a arr=(a b)
    shlib::arr_append arr c
    [[ "${#arr[@]}" == "3" ]]
    [[ "${arr[2]}" == "c" ]]
}

@test "shlib::arr_append handles elements with spaces" {
    local -a arr=()
    shlib::arr_append arr "hello world" "foo bar"
    [[ "${#arr[@]}" == "2" ]]
    [[ "${arr[0]}" == "hello world" ]]
}

@test "shlib::arr_append multiple to empty array" {
    local -a arr=()
    shlib::arr_append arr "a" "b" "c"
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[2]}" == "c" ]]
}

@test "shlib::arr_append to empty array" {
    local -a arr=()
    shlib::arr_append arr "first"
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "first" ]]
}
