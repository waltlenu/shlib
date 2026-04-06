# Append elements to an array
planets=(Mercury Venus Earth)
echo "Before: (${planets[*]})"
shlib::arr_append planets "Mars" "Jupiter"
echo "After arr_append: (${planets[*]})"
