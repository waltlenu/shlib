_header shlib::str_trim
raw="   Crab Nebula   "
echo "Before: [$raw]"
_show shlib::str_trim "$raw"
echo "After: [$(shlib::str_trim "$raw")]"
