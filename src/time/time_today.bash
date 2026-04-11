# @description Get current date as YYYY-MM-DD
# @stdout Current date in YYYY-MM-DD format
# @exitcode 0 Always succeeds
# @example
#   shlib::time_today  # outputs: 2024-01-01
shlib::time_today() {
    date +%Y-%m-%d
}
