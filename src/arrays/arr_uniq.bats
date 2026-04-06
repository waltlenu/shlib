@test "shlib::arr_uniq case-sensitive duplicates" {
    local -a arr=("A" "a" "B" "b" "A")
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "A" ]]
    [[ "${arr[1]}" == "a" ]]
    [[ "${arr[2]}" == "B" ]]
    [[ "${arr[3]}" == "b" ]]
}

@test "shlib::arr_uniq handles array with all duplicates" {
    local -a arr=(x x x x)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "x" ]]
}

@test "shlib::arr_uniq handles array with no duplicates" {
    local -a arr=(a b c d)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[3]}" == "d" ]]
}

@test "shlib::arr_uniq handles elements with spaces" {
    local -a arr=("hello world" "foo bar" "hello world" "baz")
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "hello world" ]]
    [[ "${arr[1]}" == "foo bar" ]]
    [[ "${arr[2]}" == "baz" ]]
}

@test "shlib::arr_uniq handles empty array" {
    local -a arr=()
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 0 ]]
}

@test "shlib::arr_uniq handles single element" {
    local -a arr=(only)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 1 ]]
    [[ "${arr[0]}" == "only" ]]
}

@test "shlib::arr_uniq preserves order of first occurrence" {
    local -a arr=(cherry apple cherry banana apple)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 3 ]]
    [[ "${arr[0]}" == "cherry" ]]
    [[ "${arr[1]}" == "apple" ]]
    [[ "${arr[2]}" == "banana" ]]
}

@test "shlib::arr_uniq removes duplicates" {
    local -a arr=(a b a c b d)
    shlib::arr_uniq arr
    [[ ${#arr[@]} -eq 4 ]]
    [[ "${arr[0]}" == "a" ]]
    [[ "${arr[1]}" == "b" ]]
    [[ "${arr[2]}" == "c" ]]
    [[ "${arr[3]}" == "d" ]]
}
