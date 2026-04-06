_header shlib::arr_insert
planets=(Mercury Venus Mars Jupiter)
echo "Before: (${planets[*]})"
_run shlib::arr_insert planets 2 "Earth"
echo "After: (${planets[*]})"
