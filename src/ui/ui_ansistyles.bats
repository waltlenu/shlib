@test "shlib::ui_ansistyles outputs text styles" {
    run shlib::ui_ansistyles
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Text Styles"* ]]
    [[ "$output" == *"Bold"* ]]
    [[ "$output" == *"Underline"* ]]
    [[ "$output" == *"Italic"* ]]
}

@test "shlib::ui_ansistyles produces non-empty output" {
    run shlib::ui_ansistyles
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}
