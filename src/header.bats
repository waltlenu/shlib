#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031,SC2034

########################################################################
#                                                                      #
#  {{ .project }} - BATS tests                                                  #
#                                                                      #
#  Usage: bats shlib.bats                                              #
#  License: {{ .license }}                                           #
#                                                                      #
########################################################################

setup() {
    # Get the directory containing the test file (not the temp dir bats runs from)
    PROJECT_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
    # Source the library
    source "${PROJECT_DIR}/shlib.bash"
}

#######################################
# Global (minimal) logic
#######################################

@test "bash version is 3 or higher" {
    [[ "${BASH_VERSINFO[0]}" -ge 3 ]]
}

@test "bats version is 1.5.0 or higher" {
    bats_require_minimum_version "1.5.0"
}

@test "library loads successfully" {
    [[ -n "${SHLIB_LOADED}" ]]
}

@test "SHLIB_LOADED is readonly" {
    run bash -c 'source shlib.bash; SHLIB_LOADED=0 2>&1'
    [[ "$status" -ne 0 || "$output" == *"readonly"* ]]
}

@test "SHLIB_VERSION is set" {
    [[ -n "${SHLIB_VERSION}" ]]
}

@test "SHLIB_VERSION is readonly" {
    run bash -c 'source shlib.bash; SHLIB_VERSION=0 2>&1'
    [[ "$status" -ne 0 || "$output" == *"readonly"* ]]
}

@test "SHLIB_DIR is set to correct path" {
    [[ -n "${SHLIB_DIR}" ]]
    [[ -d "${SHLIB_DIR}" ]]
    [[ -f "${SHLIB_DIR}/shlib.bash" ]]
}

@test "SHLIB_ANSI_COLORNAMES has 16 elements" {
    [[ "${#SHLIB_ANSI_COLORNAMES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_COLORNAMES contains expected colors" {
    [[ "${SHLIB_ANSI_COLORNAMES[0]}" == "Black" ]]
    [[ "${SHLIB_ANSI_COLORNAMES[1]}" == "Red" ]]
    [[ "${SHLIB_ANSI_COLORNAMES[7]}" == "White" ]]
    [[ "${SHLIB_ANSI_COLORNAMES[15]}" == "Bright White" ]]
}

@test "SHLIB_ANSI_FGCODES has 16 elements" {
    [[ "${#SHLIB_ANSI_FGCODES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_FGCODES contains expected codes" {
    [[ "${SHLIB_ANSI_FGCODES[0]}" -eq 30 ]]
    [[ "${SHLIB_ANSI_FGCODES[7]}" -eq 37 ]]
    [[ "${SHLIB_ANSI_FGCODES[8]}" -eq 90 ]]
    [[ "${SHLIB_ANSI_FGCODES[15]}" -eq 97 ]]
}

@test "SHLIB_ANSI_BGCODES has 16 elements" {
    [[ "${#SHLIB_ANSI_BGCODES[@]}" -eq 16 ]]
}

@test "SHLIB_ANSI_BGCODES contains expected codes" {
    [[ "${SHLIB_ANSI_BGCODES[0]}" -eq 40 ]]
    [[ "${SHLIB_ANSI_BGCODES[7]}" -eq 47 ]]
    [[ "${SHLIB_ANSI_BGCODES[8]}" -eq 100 ]]
    [[ "${SHLIB_ANSI_BGCODES[15]}" -eq 107 ]]
}

@test "SHLIB_ANSI_STYLECODES has 9 elements" {
    [[ "${#SHLIB_ANSI_STYLECODES[@]}" -eq 9 ]]
}

@test "SHLIB_ANSI_STYLECODES contains expected codes" {
    [[ "${SHLIB_ANSI_STYLECODES[0]}" -eq 0 ]]
    [[ "${SHLIB_ANSI_STYLECODES[1]}" -eq 1 ]]
    [[ "${SHLIB_ANSI_STYLECODES[4]}" -eq 4 ]]
}

@test "SHLIB_ANSI_STYLENAMES has 9 elements" {
    [[ "${#SHLIB_ANSI_STYLENAMES[@]}" -eq 9 ]]
}

@test "SHLIB_ANSI_STYLENAMES contains expected names" {
    [[ "${SHLIB_ANSI_STYLENAMES[0]}" == "Normal" ]]
    [[ "${SHLIB_ANSI_STYLENAMES[1]}" == "Bold" ]]
    [[ "${SHLIB_ANSI_STYLENAMES[4]}" == "Underline" ]]
}
