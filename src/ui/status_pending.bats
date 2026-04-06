@test "shlib::status_pending shows hourglass" {
    run shlib::status_pending "Waiting"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
    [[ "$output" == *"Waiting"* ]]
}

@test "shlib::status_pending with empty message" {
    run shlib::status_pending ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"⏳"* ]]
}

@test "shlib::status_pendingn adds newline" {
    line_count=$(shlib::status_pendingn "Waiting" | wc -l)
    [[ "$line_count" -eq 1 ]]
}
