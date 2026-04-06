# Get the number of elements in an array
stars=(Sirius Vega Rigel Altair Polaris)
echo "Stars: (${stars[*]})"
echo "arr_len: $(shlib::arr_len stars)"
