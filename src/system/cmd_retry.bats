@test "shlib::cmd_retry captures stdout from successful attempt" {
    run shlib::cmd_retry 3 0 echo "success"
    [ "$status" -eq 0 ]
    [ "$output" = "success" ]
}

@test "shlib::cmd_retry fails after max attempts" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_retry 3 0 false
}

@test "shlib::cmd_retry fails with invalid delay" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_retry 3 -1 true
    run ! shlib::cmd_retry 3 abc true
}

@test "shlib::cmd_retry fails with invalid max_attempts" {
    bats_require_minimum_version "1.5.0"
    run ! shlib::cmd_retry 0 0 true
    run ! shlib::cmd_retry -1 0 true
    run ! shlib::cmd_retry abc 0 true
}

@test "shlib::cmd_retry succeeds on first attempt" {
    run shlib::cmd_retry 3 0 true
    [ "$status" -eq 0 ]
}

@test "shlib::cmd_retry succeeds on later attempt" {
    # Create a temp file to track attempts
    tmpfile=$(mktemp)
    echo "0" >"$tmpfile"

    # Command that fails twice then succeeds
    # shellcheck disable=SC2016
    run shlib::cmd_retry 3 0 bash -c '
        count=$(cat "'"$tmpfile"'")
        count=$((count + 1))
        echo "$count" > "'"$tmpfile"'"
        [ "$count" -ge 3 ]
    '

    [ "$status" -eq 0 ]
    rm -f "$tmpfile"
}
