# Insert an element at a specific index
planets=(Mercury Venus Mars Jupiter)
echo "Before: (${planets[*]})"
shlib::arr_insert planets 2 "Earth"
echo "After arr_insert 2 \"Earth\": (${planets[*]})"
