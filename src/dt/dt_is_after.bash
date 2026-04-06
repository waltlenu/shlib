# @description Check if timestamp A is after timestamp B
# @arg $1 int First Unix timestamp
# @arg $2 int Second Unix timestamp
# @exitcode 0 ts1 > ts2
# @exitcode 1 ts1 <= ts2
# @example
#   shlib::dt_is_after 1704153600 1704067200 && echo "later"
shlib::dt_is_after() {
    [[ "$1" -gt "$2" ]]
}
