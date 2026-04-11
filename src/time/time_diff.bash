# @description Calculate difference between timestamps
# @arg $1 int First Unix timestamp
# @arg $2 int Second Unix timestamp
# @arg $3 string Optional unit: seconds (default), minutes, hours, days, weeks
# @stdout Difference (ts1 - ts2) in specified unit (integer division)
# @exitcode 0 Always succeeds
# @example
#   shlib::time_diff 1704153600 1704067200          # outputs: 86400 (seconds)
#   shlib::time_diff 1704153600 1704067200 hours    # outputs: 24
#   shlib::time_diff 1704153600 1704067200 days     # outputs: 1
shlib::time_diff() {
    local ts1="$1"
    local ts2="$2"
    local unit="${3:-seconds}"
    local diff=$((ts1 - ts2))
    local divisor=1

    case "$unit" in
        second | seconds) divisor=1 ;;
        minute | minutes) divisor=60 ;;
        hour | hours) divisor=3600 ;;
        day | days) divisor=86400 ;;
        week | weeks) divisor=604800 ;;
        *) divisor=1 ;;
    esac

    echo $((diff / divisor))
}
