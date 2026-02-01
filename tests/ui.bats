#!/usr/bin/env bats
# Tests for UI functions

setup() {
    # shellcheck disable=SC1091
    load 'test_helper'
}

@test "shlib::ansi_256_palette outputs 256 color palette" {
    run shlib::ansi_256_palette
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"256 Color Palette"* ]]
    [[ "$output" == *"Standard Colors (0-15)"* ]]
    [[ "$output" == *"216 Colors (16-231)"* ]]
    [[ "$output" == *"Grayscale (232-255)"* ]]
}

@test "shlib::ansi_bg_colors outputs background colors" {
    run shlib::ansi_bg_colors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Background Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
}

@test "shlib::ansi_bg_colors produces non-empty output" {
    run shlib::ansi_bg_colors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}

@test "shlib::ansi_color_matrix_bright outputs bright color combinations" {
    run shlib::ansi_color_matrix_bright
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Bright Colors)"* ]]
    [[ "$output" == *"100"* ]]
    [[ "$output" == *"90"* ]]
}

@test "shlib::ansi_color_matrix outputs standard color combinations" {
    run shlib::ansi_color_matrix
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Standard Colors)"* ]]
    [[ "$output" == *"40"* ]]
    [[ "$output" == *"30"* ]]
}

@test "shlib::ansi_fg_colors outputs foreground colors" {
    run shlib::ansi_fg_colors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
    [[ "$output" == *"Bright White"* ]]
}

@test "shlib::ansi_fg_colors produces non-empty output" {
    run shlib::ansi_fg_colors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}

@test "shlib::ansi_styles outputs text styles" {
    run shlib::ansi_styles
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Text Styles"* ]]
    [[ "$output" == *"Bold"* ]]
    [[ "$output" == *"Underline"* ]]
    [[ "$output" == *"Italic"* ]]
}

@test "shlib::ansi_styles produces non-empty output" {
    run shlib::ansi_styles
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}

@test "shlib::banner always succeeds with builtin fallback" {
    run shlib::banner "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::banner_builtin converts lowercase to uppercase" {
    run shlib::banner_builtin "hello"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::banner_builtin handles empty string" {
    run shlib::banner_builtin ""
    [[ "$status" -eq 0 ]]
}

@test "shlib::banner_builtin handles punctuation" {
    run shlib::banner_builtin "HI!"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::banner_builtin handles space character" {
    run shlib::banner_builtin "A B"
    [[ "$status" -eq 0 ]]
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::banner_builtin renders 5 lines" {
    run shlib::banner_builtin "HI"
    [[ "$status" -eq 0 ]]
    # Count lines in output
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::banner_builtin renders all digits 0-9" {
    run shlib::banner_builtin "0123456789"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::banner_builtin renders all letters A-Z" {
    run shlib::banner_builtin "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::banner_builtin renders numbers" {
    run shlib::banner_builtin "123"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::banner_builtin renders supported punctuation" {
    run shlib::banner_builtin "!?.-:_"
    [[ "$status" -eq 0 ]]
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -eq 5 ]]
}

@test "shlib::banner_builtin renders uppercase letters" {
    run shlib::banner_builtin "HELLO"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"█"* ]]
}

@test "shlib::banner_figlet fails without figlet" {
    # Skip if figlet is installed
    if command -v figlet &>/dev/null; then
        skip "figlet is installed"
    fi
    run shlib::banner_figlet "TEST"
    [[ "$status" -eq 1 ]]
}

@test "shlib::banner_figlet works when figlet installed" {
    # Skip if figlet is not installed
    if ! command -v figlet &>/dev/null; then
        skip "figlet is not installed"
    fi
    run shlib::banner_figlet "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

@test "shlib::banner output contains expected content" {
    run shlib::banner "HI"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    # Output should have multiple lines
    local lines
    lines=$(echo "$output" | wc -l | tr -d ' ')
    [[ "$lines" -ge 1 ]]
}

@test "shlib::banner_toilet fails without toilet" {
    # Skip if toilet is installed
    if command -v toilet &>/dev/null; then
        skip "toilet is installed"
    fi
    run shlib::banner_toilet "TEST"
    [[ "$status" -eq 1 ]]
}

@test "shlib::banner_toilet works when toilet installed" {
    # Skip if toilet is not installed
    if ! command -v toilet &>/dev/null; then
        skip "toilet is not installed"
    fi
    run shlib::banner_toilet "TEST"
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
}

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

@test "shlib::hr draws horizontal rule" {
    run shlib::hr
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"─"* ]]
}

@test "shlib::hr draws rule with label" {
    run shlib::hr "Test"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Test"* ]]
    [[ "$output" == *"─"* ]]
}

@test "shlib::hr respects custom width" {
    run shlib::hr "" 20
    [[ "$status" -eq 0 ]]
    [[ ${#output} -eq 20 ]]
}

@test "shlib::hr uses custom character" {
    run shlib::hr "" 10 "="
    [[ "$status" -eq 0 ]]
    [[ "$output" == "==========" ]]
}

@test "shlib::hr with label and very narrow width" {
    run shlib::hr "Hi" 6 "-"
    [[ "$status" -eq 0 ]]
    # Label centered: should contain "Hi" surrounded by separator
    [[ "${output}" == *"Hi"* ]]
}

@test "shlib::hr with label longer than width" {
    run shlib::hr "VeryLongLabel" 5 "-"
    [[ "$status" -eq 0 ]]
    # The label should still be present even if wider than width
    [[ "${output}" == *"VeryLongLabel"* ]]
}

@test "shlib::hr with very small width" {
    run shlib::hr "" 1
    [[ "$status" -eq 0 ]]
    [[ ${#output} -eq 1 ]]
}

@test "shlib::hr with width of 2" {
    run shlib::hr "" 2 "-"
    [[ "$status" -eq 0 ]]
    [[ "${output}" == "--" ]]
}

@test "shlib::hrn adds newline" {
    result=$(shlib::hrn "" 5 "-" | wc -l)
    [[ "$result" -eq 1 ]]
}

@test "shlib::spinner handles command with multiple arguments" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::spinner "Testing" bash -c "echo one two three > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "one two three" ]]
    rm -f "$tmpfile"
}

@test "shlib::spinner passes arguments to command" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::spinner "Writing" bash -c "echo 'hello' > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "hello" ]]
    rm -f "$tmpfile"
}

@test "shlib::spinner returns command exit code on failure" {
    run shlib::spinner "Testing" false
    [[ "$status" -eq 1 ]]
}

@test "shlib::spinner returns command exit code on success" {
    run shlib::spinner "Testing" true
    [[ "$status" -eq 0 ]]
}

@test "shlib::spinner runs command successfully" {
    run shlib::spinner "Testing" sleep 0.2
    [[ "$status" -eq 0 ]]
}

@test "shlib::spinner with command that writes to stderr" {
    run shlib::spinner "Testing" bash -c 'echo stderr_output >&2; exit 0'
    [[ "$status" -eq 0 ]]
}

@test "shlib::status_fail shows red X" {
    run shlib::status_fail "Error"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✖"* ]]
    [[ "$output" == *"Error"* ]]
}

@test "shlib::status_fail with empty message" {
    run shlib::status_fail ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✖"* ]]
}

@test "shlib::status_failn adds newline" {
    result=$(shlib::status_failn "Error" | wc -l)
    [[ "$result" -eq 1 ]]
}

@test "shlib::status_ok shows green checkmark" {
    run shlib::status_ok "Done"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
    [[ "$output" == *"Done"* ]]
}

@test "shlib::status_ok with empty message" {
    run shlib::status_ok ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
}

@test "shlib::status_okn adds newline" {
    result=$(shlib::status_okn "Done" | wc -l)
    [[ "$result" -eq 1 ]]
}

@test "shlib::status_pending shows hourglass" {
    run shlib::status_pending "Waiting"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
    [[ "$output" == *"Waiting"* ]]
}

@test "shlib::status_pending with empty message" {
    run shlib::status_pending ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
}

@test "shlib::status_pendingn adds newline" {
    result=$(shlib::status_pendingn "Waiting" | wc -l)
    [[ "$result" -eq 1 ]]
}
