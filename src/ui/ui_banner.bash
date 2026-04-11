# @description Render text as ASCII art banner using best available method
# @arg $1 string The text to render
# @stdout ASCII art banner (toilet > figlet > builtin)
# @exitcode 0 Always succeeds (falls back to builtin)
# @example
#   shlib::ui_banner "HELLO"
shlib::ui_banner() {
    local text="$1"

    # Prefer toilet (supports colors), then figlet, then builtin
    if shlib::cmd_exists toilet; then
        toilet -- "$text"
    elif shlib::cmd_exists figlet; then
        figlet -- "$text"
    else
        shlib::ui_banner_builtin "$text"
    fi
}
