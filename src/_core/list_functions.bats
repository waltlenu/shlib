@test "shlib::list_functions only includes shlib:: functions" {
    run shlib::list_functions
    while IFS= read -r line; do
        [[ "$line" == shlib::* ]]
    done <<<"$output"
}

@test "shlib::list_functions output is sorted" {
    run shlib::list_functions
    first_line="${lines[0]}"
    [[ "$first_line" == "shlib::arr_append" ]]
}

@test "shlib::list_functions returns function names" {
    run shlib::list_functions
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"shlib::version"* ]]
    [[ "$output" == *"shlib::list_functions"* ]]
}
