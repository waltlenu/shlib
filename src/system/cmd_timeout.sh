# Run a command with a timeout
if shlib::cmd_timeout 2 sleep 1; then
    shlib::cinfon "Command completed within timeout"
fi
if ! shlib::cmd_timeout 1 sleep 5; then
    shlib::cwarnn "Command timed out (expected)"
fi
