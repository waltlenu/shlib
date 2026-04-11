# @description Get current datetime in ISO 8601 format
# @arg $1 string Optional: "local" for local time, default is UTC
# @stdout Current datetime in ISO 8601 format
# @exitcode 0 Always succeeds
# @example
#   shlib::time_nowiso         # outputs: 2024-01-01T12:00:00Z
#   shlib::time_nowiso local   # outputs: 2024-01-01T07:00:00-05:00
shlib::time_nowiso() {
    local zone="${1:-}"
    if [[ "$zone" == "local" ]]; then
        date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/'
    else
        date -u +%Y-%m-%dT%H:%M:%SZ
    fi
}
