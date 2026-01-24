#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "library loads successfully" {
    [[ -n "${SHLIB_LOADED}" ]]
}

@test "bash version is 3 or higher" {
    [[ "${BASH_VERSINFO[0]}" -ge 3 ]]
}

@test "SHLIB_VERSION is set" {
    [[ -n "${SHLIB_VERSION}" ]]
}

@test "SHLIB_DIR is set to correct path" {
    [[ -n "${SHLIB_DIR}" ]]
    [[ -d "${SHLIB_DIR}" ]]
    [[ -f "${SHLIB_DIR}/shlib.sh" ]]
}

@test "SHLIB_ANSI_COLOR_NAMES has 16 elements" {
    [[ "${#SHLIB_ANSI_COLOR_NAMES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_COLOR_NAMES contains expected colors" {
    [[ "${SHLIB_ANSI_COLOR_NAMES[0]}" == "Black" ]]
    [[ "${SHLIB_ANSI_COLOR_NAMES[1]}" == "Red" ]]
    [[ "${SHLIB_ANSI_COLOR_NAMES[7]}" == "White" ]]
    [[ "${SHLIB_ANSI_COLOR_NAMES[15]}" == "Bright White" ]]
}

@test "SHLIB_ANSI_FG_CODES has 16 elements" {
    [[ "${#SHLIB_ANSI_FG_CODES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_FG_CODES contains expected codes" {
    [[ "${SHLIB_ANSI_FG_CODES[0]}" -eq 30 ]]
    [[ "${SHLIB_ANSI_FG_CODES[7]}" -eq 37 ]]
    [[ "${SHLIB_ANSI_FG_CODES[8]}" -eq 90 ]]
    [[ "${SHLIB_ANSI_FG_CODES[15]}" -eq 97 ]]
}

@test "SHLIB_ANSI_BG_CODES has 16 elements" {
    [[ "${#SHLIB_ANSI_BG_CODES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_BG_CODES contains expected codes" {
    [[ "${SHLIB_ANSI_BG_CODES[0]}" -eq 40 ]]
    [[ "${SHLIB_ANSI_BG_CODES[7]}" -eq 47 ]]
    [[ "${SHLIB_ANSI_BG_CODES[8]}" -eq 100 ]]
    [[ "${SHLIB_ANSI_BG_CODES[15]}" -eq 107 ]]
}

@test "SHLIB_ANSI_STYLE_CODES has 9 elements" {
    [[ "${#SHLIB_ANSI_STYLE_CODES[@]}" -eq 9 ]]
}

@test "SHLIB_ANSI_STYLE_CODES contains expected codes" {
    [[ "${SHLIB_ANSI_STYLE_CODES[0]}" -eq 0 ]]
    [[ "${SHLIB_ANSI_STYLE_CODES[1]}" -eq 1 ]]
    [[ "${SHLIB_ANSI_STYLE_CODES[4]}" -eq 4 ]]
}

@test "SHLIB_ANSI_STYLE_NAMES has 9 elements" {
    [[ "${#SHLIB_ANSI_STYLE_NAMES[@]}" -eq 9 ]]
}

@test "SHLIB_ANSI_STYLE_NAMES contains expected names" {
    [[ "${SHLIB_ANSI_STYLE_NAMES[0]}" == "Normal" ]]
    [[ "${SHLIB_ANSI_STYLE_NAMES[1]}" == "Bold" ]]
    [[ "${SHLIB_ANSI_STYLE_NAMES[4]}" == "Underline" ]]
}

@test "shlib::version outputs version string" {
    result="$(shlib::version)"
    [[ "${result}" == "${SHLIB_VERSION}" ]]
}

@test "shlib::command_exists finds existing command" {
    shlib::command_exists bash
}

@test "shlib::command_exists returns false for missing command" {
    ! shlib::command_exists nonexistent_command_12345
}
