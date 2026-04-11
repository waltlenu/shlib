@test "shlib::ui_header outputs bold message" {
    run shlib::ui_header "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
}

@test "shlib::ui_header with empty string" {
    run shlib::ui_header ""
    [[ "$status" -eq 0 ]]
    # Output should just be the ANSI codes with empty content
    [[ "${output}" == $'\033[1m\033[0m' ]]
}

@test "shlib::ui_headern outputs bold message" {
    run shlib::ui_headern "test header"
    [[ "${output}" == $'\033[1mtest header\033[0m' ]]
}

@test "shlib::ui_headern with empty string" {
    run shlib::ui_headern ""
    [[ "$status" -eq 0 ]]
}
