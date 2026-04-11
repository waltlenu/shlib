# @description Check if timestamp A is before timestamp B
# @arg $1 int First Unix timestamp
# @arg $2 int Second Unix timestamp
# @exitcode 0 ts1 < ts2
# @exitcode 1 ts1 >= ts2
# @example
#   shlib::time_isbefore 1704067200 1704153600 && echo "earlier"
shlib::time_isbefore() {
    [[ "$1" -lt "$2" ]]
}
