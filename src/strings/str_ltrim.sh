_header shlib::str_ltrim
raw="   Horsehead Nebula"
echo "Before: [$raw]"
_show shlib::str_ltrim "$raw"
echo "After: [$(shlib::str_ltrim "$raw")]"
