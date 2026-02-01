#!/usr/bin/env bats

setup() {
    load 'test_helper'
}

@test "bats version is 1.5.0 or higher" {
    bats_require_minimum_version "1.5.0"
}

@test "library loads successfully" {
    [[ -n "${SHLIB_LOADED}" ]]
}

@test "bash version is 3 or higher" {
    [[ "${BASH_VERSINFO[0]}" -ge 3 ]]
}
