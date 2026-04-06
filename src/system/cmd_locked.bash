# @description Run a command protected by file-based locking
# @arg $1 string Path to the lock file (a .lock directory will be created)
# @arg $2 int Timeout in seconds to acquire lock (0=non-blocking, -1=wait forever)
# @arg $@ string The command and its arguments
# @stdout Command output (if any)
# @stderr Command errors (if any)
# @exitcode 0 Command completed successfully
# @exitcode 1 Failed to acquire lock within timeout, or invalid arguments
# @exitcode * Command's exit code if lock was acquired
# @example
#   shlib::cmd_locked /tmp/myapp 5 ./deploy.sh      # wait up to 5s for lock
#   shlib::cmd_locked /tmp/myapp 0 ./critical.sh    # fail immediately if locked
#   shlib::cmd_locked /tmp/myapp -1 ./process.sh    # wait forever for lock
shlib::cmd_locked() {
    local lockfile="$1"
    local timeout="$2"
    shift 2

    # Validate lockfile path
    if [[ -z "$lockfile" ]]; then
        return 1
    fi

    # Validate timeout is an integer (including negative)
    if ! [[ "$timeout" =~ ^-?[0-9]+$ ]]; then
        return 1
    fi

    # Validate command is provided
    if [[ $# -eq 0 ]]; then
        return 1
    fi

    local lockdir="${lockfile}.lock"
    local pidfile="${lockdir}/pid"
    local start_time elapsed exit_code lock_pid

    start_time=$(date +%s)

    # Try to acquire lock
    while true; do
        # mkdir is atomic on POSIX systems - portable locking mechanism
        if mkdir "$lockdir" 2>/dev/null; then
            # Got the lock, write our PID for stale detection
            echo $$ >"$pidfile"

            # Run command
            "$@"
            exit_code=$?

            # Release lock
            rm -rf "$lockdir"

            return $exit_code
        fi

        # Check for stale lock (holding process no longer exists)
        if [[ -f "$pidfile" ]]; then
            lock_pid=$(cat "$pidfile" 2>/dev/null)
            if [[ -n "$lock_pid" ]] && ! kill -0 "$lock_pid" 2>/dev/null; then
                # Stale lock, try to remove it and retry
                rm -rf "$lockdir" 2>/dev/null
                continue
            fi
        fi

        # Check timeout
        if [[ $timeout -eq 0 ]]; then
            # Non-blocking mode, fail immediately
            return 1
        elif [[ $timeout -gt 0 ]]; then
            elapsed=$(($(date +%s) - start_time))
            if [[ $elapsed -ge $timeout ]]; then
                return 1
            fi
        fi
        # timeout -1 means wait forever

        # Wait before retrying (0.1s if available, 1s fallback for older systems)
        sleep 0.1 2>/dev/null || sleep 1
    done
}
