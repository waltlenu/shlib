@test "shlib::arr_insert handles element with spaces" {
    local -a arr=(a b c)
    shlib::arr_insert arr 1 "hello world"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[1]}" == "hello world" ]]
    [[ "${arr[2]}" == "b" ]]
}

@test "shlib::arr_insert handles index beyond array length" {
    local -a arr=(a b)
    shlib::arr_insert arr 10 "X"
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[2]}" == "X" ]]
}

@test "shlib::arr_insert handles negative index" {
    local -a arr=(a b c)
    shlib::arr_insert arr -5 "X"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "X" ]]
    [[ "${arr[1]}" == "a" ]]
}

@test "shlib::arr_insert inserts at beginning" {
    local -a arr=(a b c)
    shlib::arr_insert arr 0 "X"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "X" ]]
    [[ "${arr[1]}" == "a" ]]
}

@test "shlib::arr_insert inserts at end" {
    local -a arr=(a b c)
    shlib::arr_insert arr 3 "X"
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[2]}" == "c" ]]
    [[ "${arr[3]}" == "X" ]]
}

@test "shlib::arr_insert inserts at middle" {
    local -a arr=(a b c d)
    shlib::arr_insert arr 2 "X"
    [[ ${#arr[@]} -eq 5 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "b" ]]
    [[ "${arr[2]}" == "X" ]]
    [[ "${arr[3]}" == "c" ]]
    [[ "${arr[4]}" == "d" ]]
}

@test "shlib::arr_insert into empty array" {
    local -a arr=()
    shlib::arr_insert arr 0 "X"
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "X" ]]
}

@test "shlib::arr_insert with empty string element" {
    local -a arr=(a b c)
    shlib::arr_insert arr 1 ""
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "" ]]
    [[ "${arr[2]}" == "b" ]]
}
