#!/usr/bin/env bats
# Tests for UI functions

setup() {
    # shellcheck disable=SC1091
    load 'test_helper'
}

@test "shlib::spinner runs command successfully" {
    run shlib::spinner "Testing" sleep 0.2
    [[ "$status" -eq 0 ]]
}

@test "shlib::spinner returns command exit code on success" {
    run shlib::spinner "Testing" true
    [[ "$status" -eq 0 ]]
}

@test "shlib::spinner returns command exit code on failure" {
    run shlib::spinner "Testing" false
    [[ "$status" -eq 1 ]]
}

@test "shlib::spinner passes arguments to command" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::spinner "Writing" bash -c "echo 'hello' > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "hello" ]]
    rm -f "$tmpfile"
}

@test "shlib::spinner handles command with multiple arguments" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::spinner "Testing" bash -c "echo one two three > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "one two three" ]]
    rm -f "$tmpfile"
}

@test "shlib::color_table outputs color reference" {
    run shlib::color_table
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"ANSI Color and Escape Code Reference"* ]]
}

@test "shlib::color_table includes text styles section" {
    run shlib::color_table
    [[ "$output" == *"Text Styles"* ]]
    [[ "$output" == *"Bold"* ]]
    [[ "$output" == *"Underline"* ]]
}

@test "shlib::color_table includes foreground colors" {
    run shlib::color_table
    [[ "$output" == *"Foreground Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
}

@test "shlib::color_table includes background colors" {
    run shlib::color_table
    [[ "$output" == *"Background Colors"* ]]
}

@test "shlib::color_table includes color combinations" {
    run shlib::color_table
    [[ "$output" == *"Foreground / Background Combinations"* ]]
}

@test "shlib::color_table includes 256 color palette" {
    run shlib::color_table
    [[ "$output" == *"256 Color Palette"* ]]
}

@test "shlib::color_table includes usage examples" {
    run shlib::color_table
    [[ "$output" == *"Usage Examples"* ]]
}
