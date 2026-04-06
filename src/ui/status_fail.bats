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
    line_count=$(shlib::status_failn "Error" | wc -l)
    [[ "$line_count" -eq 1 ]]
}
