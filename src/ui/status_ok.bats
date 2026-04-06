@test "shlib::status_ok shows green checkmark" {
    run shlib::status_ok "Done"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
    [[ "$output" == *"Done"* ]]
}

@test "shlib::status_ok with empty message" {
    run shlib::status_ok ""
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"✔"* ]]
}

@test "shlib::status_okn adds newline" {
    line_count=$(shlib::status_okn "Done" | wc -l)
    [[ "$line_count" -eq 1 ]]
}
