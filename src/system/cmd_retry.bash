# @description Retry a command multiple times with optional delay
# @arg $1 int Maximum number of attempts
# @arg $2 int Delay in seconds between attempts (0 for no delay)
# @arg $@ string The command and its arguments
# @stdout Command output from the successful attempt (if any)
# @stderr Command errors (if any)
# @exitcode 0 Command succeeded within max attempts
# @exitcode 1 All attempts failed
# @example
#   shlib::cmd_retry 3 1 curl -f http://example.com   # retry 3 times, 1s delay
#   shlib::cmd_retry 5 0 test -f /path/to/file        # retry 5 times, no delay
shlib::cmd_retry() {
    local max_attempts="$1"
    local delay="$2"
    shift 2

    # Validate max_attempts is a positive number
    if ! [[ "$max_attempts" =~ ^[0-9]+$ ]] || [[ "$max_attempts" -le 0 ]]; then
        return 1
    fi

    # Validate delay is a non-negative number
    if ! [[ "$delay" =~ ^[0-9]+$ ]]; then
        return 1
    fi

    local attempt=1
    while [[ $attempt -le $max_attempts ]]; do
        if "$@"; then
            return 0
        fi

        if [[ $attempt -lt $max_attempts ]] && [[ $delay -gt 0 ]]; then
            sleep "$delay"
        fi

        ((attempt++))
    done

    return 1
}
