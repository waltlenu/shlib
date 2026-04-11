# @description Get current Unix timestamp
# @stdout The current Unix timestamp in seconds
# @exitcode 0 Always succeeds
# @example
#   shlib::time_now  # outputs: 1704067200
shlib::time_now() {
    date +%s
}
