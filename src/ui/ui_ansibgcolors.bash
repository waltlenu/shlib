# @description Display 16 background ANSI color codes (40-47, 100-107)
# @stdout A formatted table showing background colors
# @exitcode 0 Always succeeds
# @example
#   shlib::ui_ansibgcolors
shlib::ui_ansibgcolors() {
    local fg i

    printf '\033[1m%s\033[0m\n' "Background Colors"
    printf '%-20s %-10s %s\n' "Color" "Code" "Example"
    printf '%s\n' "-----------------------------------------------"
    for i in "${!SHLIB_ANSI_BG_CODES[@]}"; do
        # Use contrasting foreground for visibility
        if [[ ${SHLIB_ANSI_BG_CODES[$i]} -lt 44 ]] || [[ ${SHLIB_ANSI_BG_CODES[$i]} -ge 100 && ${SHLIB_ANSI_BG_CODES[$i]} -lt 104 ]]; then
            fg=97 # Bright white for dark backgrounds
        else
            fg=30 # Black for light backgrounds
        fi
        printf '%-20s \\033[%-5sm \033[%s;%sm%s\033[0m\n' "${SHLIB_ANSI_COLOR_NAMES[$i]}" "${SHLIB_ANSI_BG_CODES[$i]}" "${SHLIB_ANSI_BG_CODES[$i]}" "$fg" " Sample Text "
    done
}
