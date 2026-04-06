# Check if a command exists
if shlib::cmd_exists git; then
    shlib::cinfon "git is installed"
else
    shlib::cwarnn "git is not installed"
fi
if ! shlib::cmd_exists nonexistent_cmd; then
    shlib::cwarnn "nonexistent_cmd not found (expected)"
fi
