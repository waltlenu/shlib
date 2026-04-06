@test "shlib::header outputs bold message" {
    run shlib::header "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
}

@test "shlib::header with empty string" {
    run shlib::header ""
    [[ "$status" -eq 0 ]]
    # Output should just be the ANSI codes with empty content
    [[ "${output}" == $'\033[1m\033[0m' ]]
}

@test "shlib::headern outputs bold message" {
    run shlib::headern "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
}

@test "shlib::headern with empty string" {
    run shlib::headern ""
    [[ "$status" -eq 0 ]]
}
