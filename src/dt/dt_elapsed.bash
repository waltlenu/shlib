# @description Format elapsed time since start timestamp
# @arg $1 int Start Unix timestamp
# @arg $2 string Optional format: short (default), long, compact
# @stdout Elapsed time as human-readable duration
# @exitcode 0 Always succeeds
# @example
#   start=$(shlib::dt_now)
#   sleep 5
#   shlib::dt_elapsed "$start"  # outputs: 5s
shlib::dt_elapsed() {
    local start="$1"
    local format="${2:-short}"
    local now
    now=$(date +%s)
    local elapsed=$((now - start))
    shlib::dt_duration "$elapsed" "$format"
}
