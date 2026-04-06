@test "shlib::ansi_bg_colors outputs background colors" {
    run shlib::ansi_bg_colors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Background Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
}

@test "shlib::ansi_bg_colors produces non-empty output" {
    run shlib::ansi_bg_colors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}
