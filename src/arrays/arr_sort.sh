_header shlib::arr_sort
stars=(Rigel Altair Sirius Vega Betelgeuse)
echo "Before: (${stars[*]})"
_run shlib::arr_sort stars
echo "After: (${stars[*]})"
