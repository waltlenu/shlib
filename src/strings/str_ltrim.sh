# Remove leading whitespace
raw="   Horsehead Nebula"
echo "Before: [$raw]"
echo "After str_ltrim: [$(shlib::str_ltrim "$raw")]"
