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

@test "shlib::ansi_styles outputs text styles" {
    run shlib::ansi_styles
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Text Styles"* ]]
    [[ "$output" == *"Bold"* ]]
    [[ "$output" == *"Underline"* ]]
    [[ "$output" == *"Italic"* ]]
}

@test "shlib::ansi_fg_colors outputs foreground colors" {
    run shlib::ansi_fg_colors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
    [[ "$output" == *"Bright White"* ]]
}

@test "shlib::ansi_bg_colors outputs background colors" {
    run shlib::ansi_bg_colors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Background Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
}

@test "shlib::ansi_color_matrix outputs standard color combinations" {
    run shlib::ansi_color_matrix
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Standard Colors)"* ]]
    [[ "$output" == *"40"* ]]
    [[ "$output" == *"30"* ]]
}

@test "shlib::ansi_color_matrix_bright outputs bright color combinations" {
    run shlib::ansi_color_matrix_bright
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Bright Colors)"* ]]
    [[ "$output" == *"100"* ]]
    [[ "$output" == *"90"* ]]
}

@test "shlib::ansi_256_palette outputs 256 color palette" {
    run shlib::ansi_256_palette
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"256 Color Palette"* ]]
    [[ "$output" == *"Standard Colors (0-15)"* ]]
    [[ "$output" == *"216 Colors (16-231)"* ]]
    [[ "$output" == *"Grayscale (232-255)"* ]]
}

