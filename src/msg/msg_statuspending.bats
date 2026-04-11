@test "shlib::msg_statuspending shows hourglass" {
    run shlib::msg_statuspending "Waiting"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
    [[ "$output" == *"Waiting"* ]]
}

@test "shlib::msg_statuspending with empty message" {
    run shlib::msg_statuspending ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
}

@test "shlib::msg_statuspendingn adds newline" {
    line_count=$(shlib::msg_statuspendingn "Waiting" | wc -l)
    [[ "$line_count" -eq 1 ]]
}
