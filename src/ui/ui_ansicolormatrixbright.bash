# @description Display bright foreground/background color combinations matrix
# @stdout A matrix of bright FG (90-97) x BG (100-107) combinations
# @exitcode 0 Always succeeds
# @example
#   shlib::ui_ansicolormatrix_bright
shlib::ui_ansicolormatrix_bright() {
    local i j

    printf '\033[1m%s\033[0m\n' "Foreground / Background Combinations (Bright Colors)"
    printf '%-8s' ""
    for j in "${SHLIB_ANSI_BG_CODES[@]:8:8}"; do
        printf ' %-5s' "$j"
    done
    echo
    printf '%s\n' "----------------------------------------------------------------"
    for i in "${SHLIB_ANSI_FG_CODES[@]:8:8}"; do
        printf '%-8s' "$i"
        for j in "${SHLIB_ANSI_BG_CODES[@]:8:8}"; do
            printf ' \033[%s;%sm %-3s \033[0m' "$i" "$j" "Txt"
        done
        echo
    done
}
