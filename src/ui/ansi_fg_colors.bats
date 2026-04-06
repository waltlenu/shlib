@test "shlib::ansi_fg_colors outputs foreground colors" {
    run shlib::ansi_fg_colors
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground Colors"* ]]
    [[ "$output" == *"Red"* ]]
    [[ "$output" == *"Blue"* ]]
    [[ "$output" == *"Bright White"* ]]
}

@test "shlib::ansi_fg_colors produces non-empty output" {
    run shlib::ansi_fg_colors
    [[ "$status" -eq 0 ]]
    [[ -n "$output" ]]
    [[ ${#output} -gt 100 ]]
}
