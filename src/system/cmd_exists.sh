_header shlib::cmd_exists
_show shlib::cmd_exists git
if shlib::cmd_exists git; then
    shlib::cinfon "git is installed"
else
    shlib::cwarnn "git is not installed"
fi
_show shlib::cmd_exists nonexistent_cmd
if ! shlib::cmd_exists nonexistent_cmd; then
    shlib::cwarnn "nonexistent_cmd not found (expected)"
fi
