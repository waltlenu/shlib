# @description Display the 256 color palette
# @stdout The 256 color palette with standard colors, 216 colors, and grayscale
# @exitcode 0 Always succeeds
# @example
#   shlib::ansi_256_palette
shlib::ansi_256_palette() {
    local i

    printf '\033[1m%s\033[0m\n' "256 Color Palette (\\033[38;5;Nm for FG, \\033[48;5;Nm for BG)"
    echo "Standard Colors (0-15):"
    for i in {0..15}; do
        printf '\033[48;5;%sm %3s \033[0m' "$i" "$i"
        [[ $i -eq 7 ]] && echo
    done
    echo
    echo
    echo "216 Colors (16-231):"
    for i in {16..231}; do
        printf '\033[48;5;%sm %3s \033[0m' "$i" "$i"
        [[ $(((i - 15) % 18)) -eq 0 ]] && echo
    done
    echo
    echo "Grayscale (232-255):"
    for i in {232..255}; do
        printf '\033[48;5;%sm %3s \033[0m' "$i" "$i"
    done
    echo
}
