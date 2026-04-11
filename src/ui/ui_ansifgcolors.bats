@test "shlib::ui_ansifgcolors outputs foreground colors" {
    run shlib::ui_ansifgcolors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
    [[ "$output" == *"Bright White"* ]]
}

@test "shlib::ui_ansifgcolors produces non-empty output" {
    run shlib::ui_ansifgcolors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}
