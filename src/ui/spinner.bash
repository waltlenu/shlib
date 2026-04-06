# @description Run a command with a spinner animation
# @arg $1 string The message to display next to the spinner
# @arg $@ string The command and its arguments to run
# @stdout The spinner animation and message while running
# @exitcode Returns the exit code of the executed command
# @example
#   shlib::spinner "Installing packages" apt-get install -y curl
#   shlib::spinner "Building project" make -j4
shlib::spinner() {
    local message="$1"
    shift
    local -a spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local spin_idx=0
    local cmd_pid
    local exit_code

    # Run command in background
    "$@" &
    cmd_pid=$!

    # Hide cursor
    printf '\033[?25l'

    # Spinner loop
    while kill -0 "$cmd_pid" 2>/dev/null; do
        printf '\r%s %s' "${spin_chars[$spin_idx]}" "$message"
        spin_idx=$(((spin_idx + 1) % ${#spin_chars[@]}))
        sleep 0.1
    done

    # Wait for command and get exit code
    wait "$cmd_pid"
    exit_code=$?

    # Clear spinner line and show cursor
    printf '\r\033[K\033[?25h'

    return $exit_code
}
