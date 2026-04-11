@test "shlib::ui_ansicolormatrix_bright outputs bright color combinations" {
    run shlib::ui_ansicolormatrix_bright
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Bright Colors)"* ]]
    [[ "$output" == *"100"* ]]
    [[ "$output" == *"90"* ]]
}

@test "shlib::ui_ansicolormatrix outputs standard color combinations" {
    run shlib::ui_ansicolormatrix
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Foreground / Background Combinations (Standard Colors)"* ]]
    [[ "$output" == *"40"* ]]
    [[ "$output" == *"30"* ]]
}
