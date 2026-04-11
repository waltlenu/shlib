@test "shlib::ui_hr draws horizontal rule" {
    run shlib::ui_hr
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"─"* ]]
}

@test "shlib::ui_hr draws rule with label" {
    run shlib::ui_hr "Test"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"Test"* ]]
    [[ "$output" == *"─"* ]]
}

@test "shlib::ui_hr respects custom width" {
    run shlib::ui_hr "" 20
    [[ "$status" -eq 0 ]]
    [[ ${#output} -eq 20 ]]
}

@test "shlib::ui_hr uses custom character" {
    run shlib::ui_hr "" 10 "="
    [[ "$status" -eq 0 ]]
    [[ "$output" == "==========" ]]
}

@test "shlib::ui_hr with label and very narrow width" {
    run shlib::ui_hr "Hi" 6 "-"
    [[ "$status" -eq 0 ]]
    # Label centered: should contain "Hi" surrounded by separator
    [[ "${output}" == *"Hi"* ]]
}

@test "shlib::ui_hr with label longer than width" {
    run shlib::ui_hr "VeryLongLabel" 5 "-"
    [[ "$status" -eq 0 ]]
    # The label should still be present even if wider than width
    [[ "${output}" == *"VeryLongLabel"* ]]
}

@test "shlib::ui_hr with very small width" {
    run shlib::ui_hr "" 1
    [[ "$status" -eq 0 ]]
    [[ ${#output} -eq 1 ]]
}

@test "shlib::ui_hr with width of 2" {
    run shlib::ui_hr "" 2 "-"
    [[ "$status" -eq 0 ]]
    [[ "${output}" == "--" ]]
}

@test "shlib::ui_hrn adds newline" {
    line_count=$(shlib::ui_hrn "" 5 "-" | wc -l)
    [[ "$line_count" -eq 1 ]]
}
