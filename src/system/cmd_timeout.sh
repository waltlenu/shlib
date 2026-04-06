_header shlib::cmd_timeout
_show shlib::cmd_timeout 2 sleep 1
if shlib::cmd_timeout 2 sleep 1; then
    shlib::cinfon "Command completed within timeout"
fi
_show shlib::cmd_timeout 1 sleep 5
if ! shlib::cmd_timeout 1 sleep 5; then
    shlib::cwarnn "Command timed out (expected)"
fi
