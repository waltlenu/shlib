# Pad a string on the left
echo "str_padleft \"42\" 6 \"0\": [$(shlib::str_padleft "42" 6 "0")]"
echo "str_padleft \"NGC\" 8:    [$(shlib::str_padleft "NGC" 8)]"
