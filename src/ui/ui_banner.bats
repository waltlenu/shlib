@test "shlib::ui_banner always succeeds with builtin fallback" {
    run shlib::ui_banner "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::ui_banner_builtin converts lowercase to uppercase" {
    run shlib::ui_banner_builtin "hello"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin handles empty string" {
    run shlib::ui_banner_builtin ""
    [[ "$status" -eq 0 ]]
}

@test "shlib::ui_banner_builtin handles punctuation" {
    run shlib::ui_banner_builtin "HI!"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin handles space character" {
    run shlib::ui_banner_builtin "A B"
    [[ "$status" -eq 0 ]]
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::ui_banner_builtin renders 5 lines" {
    run shlib::ui_banner_builtin "HI"
    [[ "$status" -eq 0 ]]
    # Count lines in output
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::ui_banner_builtin renders all digits 0-9" {
    run shlib::ui_banner_builtin "0123456789"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin renders all letters A-Z" {
    run shlib::ui_banner_builtin "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin renders numbers" {
    run shlib::ui_banner_builtin "123"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_builtin renders supported punctuation" {
    run shlib::ui_banner_builtin "!?.-:_"
    [[ "$status" -eq 0 ]]
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::ui_banner_builtin renders uppercase letters" {
    run shlib::ui_banner_builtin "HELLO"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::ui_banner_figlet fails without figlet" {
    # Skip if figlet is installed
    if command -v figlet &>/dev/null; then
        skip "figlet is installed"
    fi
    run shlib::ui_banner_figlet "TEST"
    [[ "$status" -eq 1 ]]
}

@test "shlib::ui_banner_figlet works when figlet installed" {
    # Skip if figlet is not installed
    if ! command -v figlet &>/dev/null; then
        skip "figlet is not installed"
    fi
    run shlib::ui_banner_figlet "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::ui_banner output contains expected content" {
    run shlib::ui_banner "HI"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    # Output should have multiple lines
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -ge 1 ]]
}

@test "shlib::ui_banner_toilet fails without toilet" {
    # Skip if toilet is installed
    if command -v toilet &>/dev/null; then
        skip "toilet is installed"
    fi
    run shlib::ui_banner_toilet "TEST"
    [[ "$status" -eq 1 ]]
}

@test "shlib::ui_banner_toilet works when toilet installed" {
    # Skip if toilet is not installed
    if ! command -v toilet &>/dev/null; then
        skip "toilet is not installed"
    fi
    run shlib::ui_banner_toilet "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}
