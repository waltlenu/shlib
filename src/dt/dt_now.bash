# @description Get current Unix timestamp
# @stdout The current Unix timestamp in seconds
# @exitcode 0 Always succeeds
# @example
#   shlib::dt_now  # outputs: 1704067200
shlib::dt_now() {
    date +%s
}
