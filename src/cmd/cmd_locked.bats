@test "shlib::cmd_locked captures stdout" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 echo "locked output"
    [ "$status" -eq 0 ]
    [ "$output" = "locked output" ]
}

@test "shlib::cmd_locked detects and removes stale lock" {
    lockfile=$(mktemp -u)

    # Create stale lock with non-existent PID
    mkdir "${lockfile}.lock"
    echo 999999 >"${lockfile}.lock/pid"

    # Should succeed by detecting stale lock
    run shlib::cmd_locked "$lockfile" 0 true
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_locked fails with empty lockfile path" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_locked "" 0 true
}

@test "shlib::cmd_locked fails with invalid timeout" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)
    run ! shlib::cmd_locked "$lockfile" abc true
}

@test "shlib::cmd_locked fails with no command" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)
    run ! shlib::cmd_locked "$lockfile" 0
}

@test "shlib::cmd_locked fails with non-blocking when already locked" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)

    # Create lock manually
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"

    # Should fail immediately with timeout=0
    run ! shlib::cmd_locked "$lockfile" 0 true

    # Cleanup
    rm -rf "${lockfile}.lock"
}

@test "shlib::cmd_locked releases lock after command failure" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 false
    [ "$status" -eq 1 ]
    # Lock should be released even though command failed
    [ ! -d "${lockfile}.lock" ]
}

@test "shlib::cmd_locked returns command exit code" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 bash -c 'exit 42'
    [ "$status" -eq 42 ]
}

@test "shlib::cmd_locked runs command with lock" {
    lockfile=$(mktemp -u)
    run shlib::cmd_locked "$lockfile" 0 true
    [ "$status" -eq 0 ]
    # Lock should be released
    [ ! -d "${lockfile}.lock" ]
}

@test "shlib::cmd_locked times out when lock held too long" {
    bats_require_minimum_version "1.5.0"
    lockfile=$(mktemp -u)

    # Create lock held by current process
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"

    # Should timeout after 1 second
    run ! shlib::cmd_locked "$lockfile" 1 true

    # Cleanup
    rm -rf "${lockfile}.lock"
}

@test "shlib::cmd_locked waits for lock with positive timeout" {
    lockfile=$(mktemp -u)

    # Create lock that will be released after 1 second
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"
    (
        sleep 1
        rm -rf "${lockfile}.lock"
    ) &

    # Should succeed after lock is released (within 5s timeout)
    run shlib::cmd_locked "$lockfile" 5 true
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_locked with infinite wait (-1) acquires lock" {
    lockfile=$(mktemp -u)

    # Create lock that will be released quickly
    mkdir "${lockfile}.lock"
    echo $$ >"${lockfile}.lock/pid"
    (
        sleep 0.5
        rm -rf "${lockfile}.lock"
    ) &

    # Should wait and succeed
    run shlib::cmd_locked "$lockfile" -1 true
    [ "$status" -eq 0 ]
}
