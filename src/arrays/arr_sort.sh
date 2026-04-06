# Sort an array in lexicographic order
stars=(Rigel Altair Sirius Vega Betelgeuse)
echo "Before: (${stars[*]})"
shlib::arr_sort stars
echo "After arr_sort: (${stars[*]})"
