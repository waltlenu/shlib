# @description Check if a string is empty or contains only whitespace
# @arg $1 string The string to check
# @exitcode 0 String is empty or whitespace only
# @exitcode 1 String contains non-whitespace characters
# @example
#   shlib::str_isempty "   " && echo "empty"
shlib::str_isempty() {
    local trimmed
    trimmed="${1#"${1%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    [[ -z "$trimmed" ]]
}
