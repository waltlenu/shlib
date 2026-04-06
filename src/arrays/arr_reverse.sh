_header shlib::arr_reverse
planets=(Mercury Venus Earth Mars Jupiter)
echo "Before: (${planets[*]})"
_run shlib::arr_reverse planets
echo "After: (${planets[*]})"
