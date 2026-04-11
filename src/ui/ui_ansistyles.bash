# @description Display ANSI text styles with codes and examples
# @stdout A formatted table showing text styles
# @exitcode 0 Always succeeds
# @example
#   shlib::ui_ansistyles
shlib::ui_ansistyles() {
    local i

    printf '\033[1m%s\033[0m\n' "Text Styles"
    printf '%-15s %-10s %s\n' "Style" "Code" "Example"
    printf '%s\n' "---------------------------------------"
    for i in "${!SHLIB_ANSI_STYLE_CODES[@]}"; do
        printf '%-15s \\033[%-5sm \033[%sm%s\033[0m\n' "${SHLIB_ANSI_STYLE_NAMES[$i]}" "${SHLIB_ANSI_STYLE_CODES[$i]}" "${SHLIB_ANSI_STYLE_CODES[$i]}" "Sample Text"
    done
}
