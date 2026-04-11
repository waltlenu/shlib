@test "shlib::msg_statusok shows green checkmark" {
    run shlib::msg_statusok "Done"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
    [[ "$output" == *"Done"* ]]
}

@test "shlib::msg_statusok with empty message" {
    run shlib::msg_statusok ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
}

@test "shlib::msg_statusokn adds newline" {
    line_count=$(shlib::msg_statusokn "Done" | wc -l)
    [[ "$line_count" -eq 1 ]]
}
