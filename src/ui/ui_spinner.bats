@test "shlib::ui_spinner handles command with multiple arguments" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::ui_spinner "Testing" bash -c "echo one two three > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "one two three" ]]
    rm -f "$tmpfile"
}

@test "shlib::ui_spinner passes arguments to command" {
    local tmpfile
    tmpfile=$(mktemp)
    shlib::ui_spinner "Writing" bash -c "echo 'hello' > '$tmpfile'"
    run cat "$tmpfile"
    [[ "$output" == "hello" ]]
    rm -f "$tmpfile"
}

@test "shlib::ui_spinner returns command exit code on failure" {
    run shlib::ui_spinner "Testing" false
    [[ "$status" -eq 1 ]]
}

@test "shlib::ui_spinner returns command exit code on success" {
    run shlib::ui_spinner "Testing" true
    [[ "$status" -eq 0 ]]
}

@test "shlib::ui_spinner runs command successfully" {
    run shlib::ui_spinner "Testing" sleep 0.2
    [[ "$status" -eq 0 ]]
}

@test "shlib::ui_spinner with command that writes to stderr" {
    run shlib::ui_spinner "Testing" bash -c 'echo stderr_output >&2; exit 0'
    [[ "$status" -eq 0 ]]
}
