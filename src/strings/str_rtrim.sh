# Remove trailing whitespace
raw="Ring Nebula   "
echo "Before: [$raw]"
echo "After str_rtrim: [$(shlib::str_rtrim "$raw")]"
