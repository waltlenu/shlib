# @description Draw a horizontal rule with newline
# @arg $1 string Optional label to display in the middle
# @arg $2 int Width of the rule (default: 40)
# @arg $3 string Character to use (default: ─)
# @stdout A horizontal divider line followed by newline
# @exitcode 0 Always succeeds
# @example
#   shlib::hrn "Section Title"
shlib::hrn() {
    shlib::hr "$@"
    echo
}
