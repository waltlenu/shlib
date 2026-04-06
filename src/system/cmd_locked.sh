# Run a command protected by file-based locking
lockfile=$(mktemp -u)
if shlib::cmd_locked "$lockfile" 0 echo "Protected operation"; then
    shlib::cinfon "Locked command executed successfully"
fi
# Demonstrate lock contention
mkdir "${lockfile}.lock"
echo $$ >"${lockfile}.lock/pid"
if ! shlib::cmd_locked "$lockfile" 0 true; then
    shlib::cwarnn "Lock already held (expected)"
fi
rm -rf "${lockfile}.lock"
