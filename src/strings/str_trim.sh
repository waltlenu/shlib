# Remove leading and trailing whitespace
raw="   Crab Nebula   "
echo "Before: [$raw]"
echo "After str_trim: [$(shlib::str_trim "$raw")]"
