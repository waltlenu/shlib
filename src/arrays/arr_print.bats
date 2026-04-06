@test "shlib::arr_print handles empty array" {
    local -a arr=()
    run shlib::arr_print arr
    [[ "${output}" == "" ]]
}

@test "shlib::arr_print handles single element" {
    local -a arr=(only)
    run shlib::arr_print arr ","
    [[ "${output}" == "only" ]]
}

@test "shlib::arr_print with comma separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr ","
    [[ "${output}" == "a,b,c" ]]
}

@test "shlib::arr_print with default separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr
    [[ "${output}" == "a b c" ]]
}

@test "shlib::arr_print with elements containing the separator" {
    local -a arr=("a,b" "c,d")
    run shlib::arr_print arr ","
    # The separator is embedded in elements, output includes them
    [[ "${output}" == "a,b,c,d" ]]
}

@test "shlib::arr_print with empty string separator defaults to space" {
    # Note: arr_print uses ${2:- } which defaults empty to space
    local -a arr=(a b c)
    run shlib::arr_print arr ""
    [[ "${output}" == "a b c" ]]
}

@test "shlib::arr_print with multi-char separator" {
    local -a arr=(a b c)
    run shlib::arr_print arr " | "
    [[ "${output}" == "a | b | c" ]]
}

@test "shlib::arr_printn handles elements with spaces" {
    local -a arr=("hello world" "foo bar")
    run shlib::arr_printn arr
    [[ "${lines[0]}" == "hello world" ]]
    [[ "${lines[1]}" == "foo bar" ]]
}

@test "shlib::arr_printn handles single element" {
    local -a arr=(only)
    run shlib::arr_printn arr
    [[ "${output}" == "only" ]]
}

@test "shlib::arr_printn prints each element on new line" {
    local -a arr=(a b c)
    run shlib::arr_printn arr
    [[ "${lines[0]}" == "a" ]]
    [[ "${lines[1]}" == "b" ]]
    [[ "${lines[2]}" == "c" ]]
}

@test "shlib::arr_printn with empty array" {
    local -a arr=()
    run shlib::arr_printn arr
    [[ "${output}" == "" ]]
}
