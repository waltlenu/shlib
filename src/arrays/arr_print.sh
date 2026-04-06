# Print array elements with custom separators
quarks=(up down charm strange top bottom)
echo "arr_print with space: $(shlib::arr_print quarks)"
echo "arr_print with comma: $(shlib::arr_print quarks ",")"
echo "arr_print with ' | ': $(shlib::arr_print quarks " | ")"
