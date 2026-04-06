# @description Run a command with a timeout
# @arg $1 int Timeout in seconds
# @arg $@ string The command and its arguments
# @stdout Command output (if any)
# @stderr Command errors (if any)
# @exitcode 0 Command completed successfully within timeout
# @exitcode 124 Command timed out
# @exitcode * Command's exit code if it completed before timeout
# @example
#   shlib::cmd_timeout 5 sleep 2    # succeeds
#   shlib::cmd_timeout 1 sleep 10   # times out with exit code 124
shlib::cmd_timeout() {
    local timeout="$1"
    shift

    # Validate timeout is a positive number
    if ! [[ "$timeout" =~ ^[0-9]+$ ]] || [[ "$timeout" -le 0 ]]; then
        return 1
    fi

    # Run command in background
    "$@" &
    local cmd_pid=$!

    # Start a watchdog timer in background
    (
        sleep "$timeout"
        kill -0 "$cmd_pid" 2>/dev/null && kill -TERM "$cmd_pid" 2>/dev/null
    ) &
    local watchdog_pid=$!

    # Wait for command to complete
    local exit_code
    wait "$cmd_pid" 2>/dev/null
    exit_code=$?

    # Kill the watchdog if command finished first
    kill -0 "$watchdog_pid" 2>/dev/null && kill "$watchdog_pid" 2>/dev/null
    wait "$watchdog_pid" 2>/dev/null

    # Check if command was killed by timeout (SIGTERM = 143, or we check if it was killed)
    if [[ $exit_code -eq 143 ]] || [[ $exit_code -eq 137 ]]; then
        return 124
    fi

    return $exit_code
}
