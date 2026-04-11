@test "shlib::msg_statusfail shows red X" {
    run shlib::msg_statusfail "Error"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✖"* ]]
    [[ "$output" == *"Error"* ]]
}

@test "shlib::msg_statusfail with empty message" {
    run shlib::msg_statusfail ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✖"* ]]
}

@test "shlib::msg_statusfailn adds newline" {
    line_count=$(shlib::msg_statusfailn "Error" | wc -l)
    [[ "$line_count" -eq 1 ]]
}
