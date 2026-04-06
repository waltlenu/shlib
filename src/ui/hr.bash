# @description Draw a horizontal rule/divider line
# @arg $1 string Optional label to display in the middle
# @arg $2 int Width of the rule (default: 40)
# @arg $3 string Character to use (default: ─)
# @stdout A horizontal divider line
# @exitcode 0 Always succeeds
# @example
#   shlib::hr
#   shlib::hr "Section"
#   shlib::hr "Title" 60 "="
shlib::hr() {
    local label="${1:-}"
    local width="${2:-40}"
    local char="${3:-─}"
    local i line=""

    if [[ -z "$label" ]]; then
        # No label, just draw the line
        for ((i = 0; i < width; i++)); do
            line="${line}${char}"
        done
    else
        # Calculate padding for centered label
        local label_len=${#label}
        local padding=$(((width - label_len - 2) / 2))
        local left_pad="" right_pad=""

        for ((i = 0; i < padding; i++)); do
            left_pad="${left_pad}${char}"
        done

        # Account for odd widths
        local right_padding=$((width - padding - label_len - 2))
        for ((i = 0; i < right_padding; i++)); do
            right_pad="${right_pad}${char}"
        done

        line="${left_pad} ${label} ${right_pad}"
    fi

    printf '%s' "$line"
}
