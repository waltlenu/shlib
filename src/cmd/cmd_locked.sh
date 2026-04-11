_header shlib::cmd_locked
lockfile=$(mktemp -u)
_show shlib::cmd_locked "$lockfile" 0 echo "Protected operation"
if shlib::cmd_locked "$lockfile" 0 echo "Protected operation"; then
    shlib::msg_cinfon "Locked command executed successfully"
fi
# Demonstrate lock contention
mkdir "${lockfile}.lock"
echo $$ >"${lockfile}.lock/pid"
_show shlib::cmd_locked "$lockfile" 0 true
if ! shlib::cmd_locked "$lockfile" 0 true; then
    shlib::msg_cwarnn "Lock already held (expected)"
fi
rm -rf "${lockfile}.lock"
