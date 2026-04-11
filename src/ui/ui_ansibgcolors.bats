@test "shlib::ui_ansibgcolors outputs background colors" {
    run shlib::ui_ansibgcolors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Background Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
}

@test "shlib::ui_ansibgcolors produces non-empty output" {
    run shlib::ui_ansibgcolors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}
