# @description Render text as ASCII art banner using figlet
# @arg $1 string The text to render
# @arg $2 string Font name (optional, default: standard)
# @stdout ASCII art from figlet
# @exitcode 0 Success
# @exitcode 1 figlet not installed
# @example
#   shlib::banner_figlet "Hello"
#   shlib::banner_figlet "Hello" "banner"
shlib::banner_figlet() {
    local text="$1"
    local font="${2:-standard}"

    if ! shlib::cmd_exists figlet; then
        return 1
    fi

    figlet -f "$font" "$text"
}
