# Reverse an array in place
planets=(Mercury Venus Earth Mars Jupiter)
echo "Before: (${planets[*]})"
shlib::arr_reverse planets
echo "After arr_reverse: (${planets[*]})"
