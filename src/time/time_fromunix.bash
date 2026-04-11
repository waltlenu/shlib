# @description Format Unix timestamp with format string
# @arg $1 int Unix timestamp
# @arg $2 string Format string (strftime compatible)
# @stdout Formatted date/time string
# @exitcode 0 Success
# @exitcode 1 Invalid timestamp or format
# @example
#   shlib::time_fromunix 1704067200 "%Y-%m-%d"  # outputs: 2024-01-01
#   shlib::time_fromunix 1704067200 "%H:%M:%S"  # outputs: 12:00:00
shlib::time_fromunix() {
    local timestamp="$1"
    local format="$2"

    # Try BSD date first (macOS)
    if date -r "$timestamp" +"$format" 2>/dev/null; then
        return 0
    fi

    # Try GNU date (Linux)
    if date -d "@$timestamp" +"$format" 2>/dev/null; then
        return 0
    fi

    return 1
}
