_header shlib::arr_append
planets=(Mercury Venus Earth)
echo "Before: (${planets[*]})"
_run shlib::arr_append planets "Mars" "Jupiter"
echo "After: (${planets[*]})"
