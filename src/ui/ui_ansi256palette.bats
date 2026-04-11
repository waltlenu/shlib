@test "shlib::ui_ansi256palette outputs 256 color palette" {
    run shlib::ui_ansi256palette
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"256 Color Palette"* ]]
    [[ "$output" == *"Standard Colors (0-15)"* ]]
    [[ "$output" == *"216 Colors (16-231)"* ]]
    [[ "$output" == *"Grayscale (232-255)"* ]]
}
