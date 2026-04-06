@test "shlib::list_variables only includes SHLIB_ variables" {
    run shlib::list_variables
    while IFS= read -r line; do
        [[ "$line" == SHLIB_* ]]
    done <<<"$output"
}

@test "shlib::list_variables output is sorted" {
    run shlib::list_variables
    first_line="${lines[0]}"
    [[ "$first_line" == "SHLIB_ANSI_BG_CODES" ]]
}

@test "shlib::list_variables returns variable names" {
    run shlib::list_variables
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"SHLIB_VERSION"* ]]
    [[ "$output" == *"SHLIB_DIR"* ]]
    [[ "$output" == *"SHLIB_LOADED"* ]]
}
