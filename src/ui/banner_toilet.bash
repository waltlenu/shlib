# @description Render text as ASCII art banner using toilet
# @arg $1 string The text to render
# @arg $2 string Font name (optional, default: standard)
# @arg $3 string Filter (optional, e.g., gay, metal, border)
# @stdout ASCII art from toilet
# @exitcode 0 Success
# @exitcode 1 toilet not installed
# @example
#   shlib::banner_toilet "Hello"
#   shlib::banner_toilet "Hello" "mono12"
#   shlib::banner_toilet "Hello" "mono12" "gay"
shlib::banner_toilet() {
    local text="$1"
    local font="${2:-}"
    local filter="${3:-}"

    if ! shlib::cmd_exists toilet; then
        return 1
    fi

    local cmd="toilet"
    [[ -n "$font" ]] && cmd="$cmd -f $font"
    [[ -n "$filter" ]] && cmd="$cmd --filter $filter"
    cmd="$cmd -- "

    eval "$cmd\"\$text\""
}
