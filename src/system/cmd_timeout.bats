@test "shlib::cmd_timeout captures stdout" {
    run shlib::cmd_timeout 5 echo "hello"
    [ "$status" -eq 0 ]
    [ "$output" = "hello" ]
}

@test "shlib::cmd_timeout fails with invalid timeout" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_timeout 0 true
    run ! shlib::cmd_timeout -1 true
    run ! shlib::cmd_timeout abc true
}

@test "shlib::cmd_timeout returns 124 when command times out" {
    run shlib::cmd_timeout 1 sleep 10
    [ "$status" -eq 124 ]
}

@test "shlib::cmd_timeout returns command exit code on failure" {
    run shlib::cmd_timeout 5 bash -c 'exit 42'
    [ "$status" -eq 42 ]
}

@test "shlib::cmd_timeout returns command exit code on success" {
    run shlib::cmd_timeout 5 bash -c 'exit 0'
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_timeout runs command that completes before timeout" {
    run shlib::cmd_timeout 5 true
    [ "$status" -eq 0 ]
}
