_header shlib::cmd_exists
_show shlib::cmd_exists git
if shlib::cmd_exists git; then
    shlib::msg_cinfon "git is installed"
else
    shlib::msg_cwarnn "git is not installed"
fi
_show shlib::cmd_exists nonexistent_cmd
if ! shlib::cmd_exists nonexistent_cmd; then
    shlib::msg_cwarnn "nonexistent_cmd not found (expected)"
fi
