# @description Format seconds as human-readable duration
# @arg $1 int Number of seconds
# @arg $2 string Optional format: short (default), long, compact
# @stdout Human-readable duration string
# @exitcode 0 Always succeeds
# @example
#   shlib::time_duration 90061              # outputs: 1d 1h 1m 1s
#   shlib::time_duration 90061 long         # outputs: 1 day, 1 hour, 1 minute, 1 second
#   shlib::time_duration 90061 compact      # outputs: 1d1h1m1s
shlib::time_duration() {
    local seconds="$1"
    local format="${2:-short}"
    local negative=""

    # Handle negative durations
    if [[ $seconds -lt 0 ]]; then
        negative="-"
        seconds=$((-seconds))
    fi

    local days=$((seconds / 86400))
    local hours=$(((seconds % 86400) / 3600))
    local mins=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))

    local output=""

    case "$format" in
        long)
            local parts=()
            [[ $days -gt 0 ]] && parts+=("$days day$([[ $days -ne 1 ]] && echo "s")")
            [[ $hours -gt 0 ]] && parts+=("$hours hour$([[ $hours -ne 1 ]] && echo "s")")
            [[ $mins -gt 0 ]] && parts+=("$mins minute$([[ $mins -ne 1 ]] && echo "s")")
            [[ $secs -gt 0 || ${#parts[@]} -eq 0 ]] && parts+=("$secs second$([[ $secs -ne 1 ]] && echo "s")")

            local i
            for ((i = 0; i < ${#parts[@]}; i++)); do
                [[ $i -gt 0 ]] && output+=", "
                output+="${parts[$i]}"
            done
            ;;
        compact)
            [[ $days -gt 0 ]] && output+="${days}d"
            [[ $hours -gt 0 ]] && output+="${hours}h"
            [[ $mins -gt 0 ]] && output+="${mins}m"
            [[ $secs -gt 0 || -z "$output" ]] && output+="${secs}s"
            ;;
        short | *)
            [[ $days -gt 0 ]] && output+="${days}d "
            [[ $hours -gt 0 ]] && output+="${hours}h "
            [[ $mins -gt 0 ]] && output+="${mins}m "
            [[ $secs -gt 0 || -z "$output" ]] && output+="${secs}s"
            output="${output% }" # trim trailing space
            ;;
    esac

    echo "${negative}${output}"
}
