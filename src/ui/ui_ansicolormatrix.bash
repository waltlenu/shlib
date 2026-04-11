# @description Display standard foreground/background color combinations matrix
# @stdout A matrix of standard FG (30-37) x BG (40-47) combinations
# @exitcode 0 Always succeeds
# @example
#   shlib::ui_ansicolormatrix
shlib::ui_ansicolormatrix() {
    local i j

    printf '\033[1m%s\033[0m\n' "Foreground / Background Combinations (Standard Colors)"
    printf '%-8s' ""
    for j in "${SHLIB_ANSI_BGCODES[@]:0:8}"; do
        printf ' %-5s' "$j"
    done
    echo
    printf '%s\n' "--------------------------------------------------------"
    for i in "${SHLIB_ANSI_FGCODES[@]:0:8}"; do
        printf '%-8s' "$i"
        for j in "${SHLIB_ANSI_BGCODES[@]:0:8}"; do
            printf ' \033[%s;%sm %-3s \033[0m' "$i" "$j" "Txt"
        done
        echo
    done
}
