# @description Add time units to timestamp
# @arg $1 int Unix timestamp
# @arg $2 int Amount to add (can be negative)
# @arg $3 string Unit: seconds, minutes, hours, days, weeks
# @stdout New Unix timestamp
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_add 1704067200 1 days    # add 1 day
#   shlib::dt_add 1704067200 -2 hours  # subtract 2 hours
shlib::dt_add() {
    local timestamp="$1"
    local amount="$2"
    local unit="$3"
    local multiplier=1

    case "$unit" in
        second | seconds) multiplier=1 ;;
        minute | minutes) multiplier=60 ;;
        hour | hours) multiplier=3600 ;;
        day | days) multiplier=86400 ;;
        week | weeks) multiplier=604800 ;;
        *) multiplier=1 ;;
    esac

    echo $((timestamp + amount * multiplier))
}
