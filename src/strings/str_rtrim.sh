_header shlib::str_rtrim
raw="Ring Nebula   "
echo "Before: [$raw]"
_show shlib::str_rtrim "$raw"
echo "After: [$(shlib::str_rtrim "$raw")]"
