@test "shlib::arr_merge handles elements with spaces" {
    local -a arr1=("hello world")
    local -a arr2=("foo bar" "baz")
    local -a merged
    shlib::arr_merge merged arr1 arr2
    [[ ${#merged[@]} -eq 3 ]]
    [[ "${merged[0]}" == "hello world" ]]
    [[ "${merged[1]}" == "foo bar" ]]
    [[ "${merged[2]}" == "baz" ]]
}

@test "shlib::arr_merge handles empty source arrays" {
    local -a arr1=(a b)
    local -a arr2=()
    local -a arr3=(c d)
    local -a merged
    shlib::arr_merge merged arr1 arr2 arr3
    [[ ${#merged[@]} -eq 4 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[2]}" == "c" ]]
}

@test "shlib::arr_merge merges three arrays" {
    local -a arr1=(a b)
    local -a arr2=(c)
    local -a arr3=(d e f)
    local -a merged
    shlib::arr_merge merged arr1 arr2 arr3
    [[ ${#merged[@]} -eq 6 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[2]}" == "c" ]]
    [[ "${merged[5]}" == "f" ]]
}

@test "shlib::arr_merge merges two arrays" {
    local -a arr1=(a b)
    local -a arr2=(c d)
    local -a merged
    shlib::arr_merge merged arr1 arr2
    [[ ${#merged[@]} -eq 4 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[1]}" == "b" ]]
    [[ "${merged[2]}" == "c" ]]
    [[ "${merged[3]}" == "d" ]]
}

@test "shlib::arr_merge overwrites existing destination" {
    local -a arr1=(a b)
    local -a merged=(x y z)
    shlib::arr_merge merged arr1
    [[ ${#merged[@]} -eq 2 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[1]}" == "b" ]]
}

@test "shlib::arr_merge with no source arrays" {
    local -a merged
    shlib::arr_merge merged
    [[ ${#merged[@]} -eq 0 ]]
}

@test "shlib::arr_merge with single source array" {
    local -a arr1=(a b c)
    local -a merged
    shlib::arr_merge merged arr1
    [[ ${#merged[@]} -eq 3 ]]
    [[ "${merged[0]}" == "a" ]]
    [[ "${merged[2]}" == "c" ]]
}
