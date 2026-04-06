# Pad a string on the right
echo "str_padright \"M31\" 8 \".\": [$(shlib::str_padright "M31" 8 ".")]"
echo "str_padright \"IC\" 6:      [$(shlib::str_padright "IC" 6)]"
