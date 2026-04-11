# @description Display 16 foreground ANSI color codes (30-37, 90-97)
# @stdout A formatted table showing foreground colors
# @exitcode 0 Always succeeds
# @example
#   shlib::ui_ansifgcolors
shlib::ui_ansifgcolors() {
    local i

    printf '\033[1m%s\033[0m\n' "Foreground Colors"
    printf '%-20s %-10s %s\n' "Color" "Code" "Example"
    printf '%s\n' "-----------------------------------------------"
    for i in "${!SHLIB_ANSI_FGCODES[@]}"; do
        printf '%-20s \\033[%-5sm \033[%sm%s\033[0m\n' "${SHLIB_ANSI_COLORNAMES[$i]}" "${SHLIB_ANSI_FGCODES[$i]}" "${SHLIB_ANSI_FGCODES[$i]}" "Sample Text"
    done
}
