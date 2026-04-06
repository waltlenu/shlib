_header shlib::cmd_retry
_show shlib::cmd_retry 3 0 true
if shlib::cmd_retry 3 0 true; then
    shlib::cinfon "Command succeeded on first attempt"
fi
_show shlib::cmd_retry 2 0 false
if ! shlib::cmd_retry 2 0 false; then
    shlib::cwarnn "Command failed after 2 attempts (expected)"
fi
